class Category < ActiveRecord::Base
  validates_presence_of :title
  validates_length_of :title, :allow_nil => false
end
