class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :kb_categories do |t|
      t.column :title, :string, :null => false
      t.column :description, :text
    end
  end

  def self.down
    drop_table :kb_categories
  end
end
