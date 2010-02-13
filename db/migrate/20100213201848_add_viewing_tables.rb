class AddViewingTables < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.create_viewings_table
    Article.add_viewings_columns
  end

  def self.down
    Article.drop_viewings_columns
    ActiveRecord::Base.drop_viewings_table
  end
end
