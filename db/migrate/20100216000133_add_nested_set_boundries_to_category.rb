class AddNestedSetBoundriesToCategory < ActiveRecord::Migration
  def self.up
    add_column :kb_categories, :lft, :int
    add_column :kb_categories, :rgt, :int
  end

  def self.down
    remove_column :kb_categories, :lft
    remove_column :kb_categories, :rgt
  end
end
