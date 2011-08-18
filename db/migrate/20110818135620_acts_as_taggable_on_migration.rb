class ActsAsTaggableOnMigration < ActiveRecord::Migration
  def self.up
    unless table_exists?("tags")
      create_table :tags do |t|
        t.column :name, :string
      end
    end
    
    # Check if the taggings table already exists, as this would indicate
    # the kb instance was created using the old acts_as_taggable plugin
    if table_exists?("taggings")
      begin
        add_column :taggings, :tagger_id, :integer
        add_column :taggings, :tagger_type, :string
        add_column :taggings, :context, :string
        add_index :taggings, :context
      rescue
        puts "Taggings table has likely already been updated for acts_as_taggable_on compatibility"
      end
    else
      create_table :taggings do |t|
        t.column :tag_id, :integer
        t.column :taggable_id, :integer
        t.column :tagger_id, :integer
        t.column :tagger_type, :string
        
        # You should make sure that the column created is
        # long enough to store the required class names.
        t.column :taggable_type, :string
        t.column :context, :string
        
        t.column :created_at, :datetime
      end
      
      add_index :taggings, :tag_id
      add_index :taggings, [:taggable_id, :taggable_type, :context]
    end
  end
  
  def self.down
    drop_table :taggings
    drop_table :tags
  end
  
#######
private
#######

  def table_exists?(name)
    ActiveRecord::Base.connection.tables.include?(name)
  end

end
