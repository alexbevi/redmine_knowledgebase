class ActsAsTaggableMigration < ActiveRecord::Migration
  def self.up
    return if self.table_exists?("tags") && self.table_exists?("taggings")


	unless self.table_exists?("tags")    
      create_table :tags do |t|
        t.column :name, :string
      end
    end
    
    unless self.table_exists?("taggings")
      create_table :taggings do |t|
        t.column :tag_id, :integer
        t.column :taggable_id, :integer
      
        # You should make sure that the column created is
        # long enough to store the required class names.
        t.column :taggable_type, :string
      
        t.column :created_at, :datetime
      end
    
      add_index :taggings, :tag_id
      add_index :taggings, [:taggable_id, :taggable_type]
    end
  end
  
  def self.down
    drop_table :taggings if self.table_exists?("taggings")
    drop_table :tags if self.table_exists?("tags")
  end
  
  #######
  private
  #######
  def self.table_exists?(name)
    ActiveRecord::Base.connection.tables.include?(name)
  end
end
