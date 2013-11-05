class AddUserWhitelistToCategories < ActiveRecord::Migration
  def change
    add_column :kb_categories, :user_whitelist, :string, :default => ""
  end
end
