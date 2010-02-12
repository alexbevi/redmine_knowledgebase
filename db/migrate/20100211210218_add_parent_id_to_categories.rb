class AddParentIdToCategories < ActiveRecord::Migration
  def self.up
    add_column :kb_categories, :parent_id, :int, :default => 0, :null => false
  end

  def self.down
    remove_column :kb_categories, :parent_id
  end
end