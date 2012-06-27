class UpdateTaggingsModel < ActiveRecord::Migration
  def change
    remove_index :taggings, [:taggable_id, :taggable_type]
    add_column :taggings, :tagger_id, :integer
    add_column :taggings, :tagger_type, :string
    add_column :taggings, :context, :string, :limit => 128
    add_index :taggings, [:taggable_id, :taggable_type, :context]
    ActsAsTaggableOn::Tagging.update_all(:context => "tags")
  end
end
