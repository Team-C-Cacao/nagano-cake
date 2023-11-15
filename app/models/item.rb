class Item < ApplicationRecord
  
  has_many :cart_items
  has_many :oder_details 
  belongs_to :genre
  
end
