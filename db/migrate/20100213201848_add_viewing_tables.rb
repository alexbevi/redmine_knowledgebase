class AddViewingTables < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.create_viewings_table   
  end

  def self.down    
    ActiveRecord::Base.drop_viewings_table
  end
end
