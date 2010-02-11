class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.column :title, :string, :null => false
      t.column :description, :text
    end
  end

  def self.down
    drop_table :categories
  end
end
