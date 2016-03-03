# Copyright (c) 2008 Damian Martinelli
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module ActiveRecord #:nodoc:
  module Acts #:nodoc:

    # == acts_as_viewed
    # Adds views count capabilities to any ActiveRecord object.
    # It has the ability to work with objects that have or don't special fields to keep a tally of the 
    # viewings for each object. 
    # In addition it will by default use the User model as the viewer object and keep the viewings per-user.
    # It can be configured to use another class.
    # The IP address are used to not repeat views from the same ip. Only one view are count by user or IP.
    #
    # Special methods are provided to create the viewings table and if needed, to add the special fields needed
    # to keep per-objects viewings fast for access to viewed objects. Can be easily used in migrations.
    #
    # == Example of usage:
    #
    #   class Video < ActiveRecord::Base
    #     acts_as_viewed
    #   end
    #
    #   In a controller:
    #
    #   bill = User.find_by_name 'bill'
    #   batman = Video.find_by_title 'Batman'
    #   toystory  = Video.find_by_title 'Toy Story'
    #
    #   batman.view request.remote_addr, bill
    #   toystory.view  request.remote_addr, bill
    #
    #   batman.view_count     # => 1
    #
    #
    module Viewed
     
      class ViewedError < RuntimeError; end
      
      def self.included(base) #:nodoc:
        base.extend(ClassMethods)  
      end
      
      module ClassMethods

        # Make the model viewable. 
        # The Viewing model, holding the details of the viewings, will be created dynamically if it doesn't exist.
        # 
        # * Adds a <tt>has_many :viewings</tt> association to the model for easy retrieval of the detailed viewings.
        # * Adds a <tt>has_many :viewers</tt> association to the object.
        # * Adds a <tt>has_many :viewings</tt> associations to the viewer class.
        #
        # === Options
        # * <tt>:viewing_class</tt> - 
        #   class of the model used for the viewings. Defaults to Viewing. This class will be dynamically created if not already defined.
        #   If the class is predefined, it must have in it the following definitions:
        #   <tt>belongs_to :viewed, :polymorphic => true</tt>
        #   <tt>belongs_to :viewer, :class_name => 'User', :foreign_key => :viewer_id</tt> replace user with the viewer class if needed.
        # * <tt>:viewer_class</tt> - 
        #   class of the model that creates the viewing. 
        #   Defaults to User This class will NOT be created, so it must be defined in the app. 
        #   Use the IP address to prevent multiple viewings from the same client.
        #   
        def acts_as_viewed(options = {})
          # don't allow multiple calls
          return if self.included_modules.include?(ActiveRecord::Acts::Viewed::ViewMethods)
          send :include, ActiveRecord::Acts::Viewed::ViewMethods
                    
          # Create the model for ratings if it doesn't yet exist
          viewing_class = options[:viewing_class] || 'Viewing'
          viewer_class  = options[:viewer_class]  || 'User'

          unless Object.const_defined?(viewing_class)
            Object.class_eval <<-EOV
              class #{viewing_class} < ActiveRecord::Base
                belongs_to :viewed, :polymorphic => true
                belongs_to :viewer, :class_name => #{viewer_class}, :foreign_key => :viewer_id
              end
            EOV
          end
          
          # Rails < 3
          # write_inheritable_attribute( :acts_as_viewed_options , 
          #                                { :viewing_class => viewing_class,
          #                                  :viewer_class => viewer_class } )
          # class_inheritable_reader :acts_as_viewed_options
          
          # Rails >= 3
          class_attribute :acts_as_viewed_options
          self.acts_as_viewed_options = { :viewing_class => viewing_class,
                                          :viewer_class => viewer_class }
          class_eval do
            has_many :viewings, :as => :viewed, :dependent => :delete_all, :class_name => viewing_class.to_s
            has_many(:viewers, :through => :viewings, :class_name => viewer_class.to_s)

            before_create :init_viewing_fields
          end

          # Add to the User (or whatever the viewer is) a has_many viewings 
          viewer_as_class = viewer_class.constantize
          return if viewer_as_class.instance_methods.include?('find_in_viewings')
          viewer_as_class.class_eval <<-EOS
            has_many :viewings, :foreign_key => :viewer_id, :class_name => #{viewing_class.to_s}
          EOS
        end
      end

      module ViewMethods
      
        def self.included(base) #:nodoc:
          base.extend ClassMethods
        end

        # Is this object viewed already?
        def viewed?
          return (!self.views.nil? && self.views > 0) if attributes.has_key? 'views'
          !viewings.find(:first).nil? 
        end
        
        # Get the number of viewings for this object based on the views field, 
        # or with a SQL query if the viewed objects doesn't have the views field
        def view_count
          return self.views || 0 if attributes.has_key? 'views'
          viewings.count 
        end
            
        # View the object with or without a viewer - create new or update as needed
        #
        # * <tt>ip</tt> - the viewer ip
        # * <tt>viewer</tt> - an object of the viewer class. Must be valid and with an id to be used. Or nil
        def view ip, viewer = nil
          # Sanity checks for the parameters
          viewing_class = acts_as_viewed_options[:viewing_class].constantize
          if viewer && !(acts_as_viewed_options[:viewer_class].constantize === viewer) 
            raise ViewedError, "the viewer object must be the one used when defining acts_as_viewed (or a descendent of it). other objects are not acceptable"
          end
                    
          viewing_class.transaction do
            if !viewed_by? ip, viewer
              view = viewing_class.new              
              view.viewer_id = viewer.id if viewer && !viewer.id.nil?
              view.ip = ip
              viewings << view
              target = self if attributes.has_key? 'views'
              target.views = ( (target.views || 0) + 1 ) if target 
              view.save
              target.save_without_validation if target
              return true
            else
              return false
            end
          end
        end

        # Check if an item was already viewed by the given viewer
        def viewed_by? ip, viewer = nil
          if viewer && !viewer.nil? && !(acts_as_viewed_options[:viewer_class].constantize === viewer) 
            raise ViewedError, "the viewer object must be the one used when defining acts_as_viewed (or a descendent of it). other objects are not acceptable"
          end
          if viewer && !viewer.id.nil? 
            return viewings.where(['viewer_id = ? or ip = ?', viewer.id, ip]).count > 0
          else
            return viewings.where(['ip = ?', ip]).count > 0
          end
        end
            
        private

        def init_viewing_fields #:nodoc:
          if attributes.has_key? 'views'
            self.views ||= 0 
          end
        end 

      end  

      module ClassMethods

        # Generate the viewings columns on a table, to be used when creating the table
        # in a migration. This is the preferred way to do in a migration that creates
        # new tables as it will make it as part of the table creation, and not generate
        # ALTER TABLE calls after the fact
        def generate_viewings_columns table
          table.column :views, :integer
        end

        # Create the needed columns for acts_as_viewed. 
        # To be used during migration, but can also be used in other places.
        def add_viewings_columns
          if !self.content_columns.find { |c| 'views' == c.name }
            self.connection.add_column table_name, :views, :integer, :default => '0'
            self.reset_column_information
          end            
        end

        # Remove the acts_as_viewed specific columns added with add_viewings_columns
        # To be used during migration, but can also be used in other places
        def remove_viewings_columns
          if self.content_columns.find { |c| 'views' == c.name }
            self.connection.remove_column table_name, :views
            self.reset_column_information
          end            
        end

        # Create the viewings table
        # === Options hash:
        # * <tt>:table_name</tt> - use a table name other than viewings 
        # To be used during migration, but can also be used in other places
        def create_viewings_table options = {}
          name        = options[:table_name] || :viewings
          self.connection.create_table(name) do |t|
            t.column :viewer_id,   :integer
            t.column :viewed_id,   :integer
            t.column :viewed_type, :string
            t.column :ip, :string, :limit => '24'
            t.column :created_at, :datetime
          end

          self.connection.add_index name, :viewer_id
          self.connection.add_index name, [:viewed_type, :viewed_id]
          
        end

        # Drop the viewings table. 
        # === Options hash:
        # * <tt>:table_name</tt> - the name of the viewings table, defaults to viewings
        # To be used during migration, but can also be used in other places
        def drop_viewings_table options = {}
          name = options[:table_name] || :viewings
          self.connection.drop_table name 
        end
          
        # Find all viewings for a specific viewer.
        def find_viewed_by viewer        
          viewing_class = acts_as_viewed_options[:viewing_class].constantize
          if !(acts_as_viewed_options[:viewer_class].constantize === viewer)
             raise ViewedError, "The viewer object must be the one used when defining acts_as_viewed (or a descendent of it). other objects are not acceptable" 
          end
          raise ViewedError, "Viewer must be a valid and existing object" if viewer.nil? || viewer.id.nil?
          raise ViewedError, 'Viewer must be a valid viewer' if !viewing_class.column_names.include? "viewer_id"  
          viewed_class = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s
          conds = [ 'viewed_type = ? AND viewer_id = ?', viewed_class, viewer.id ]
          acts_as_viewed_options[:viewing_class].constantize.where(:conditions => conds).collect {|r| r.viewed_type.constantize.find_by_id r.viewed.id }
        end
      end
    end
  end
end


ActiveRecord::Base.send :include, ActiveRecord::Acts::Viewed

