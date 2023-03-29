class Product < ApplicationRecord
  has_one :seller
  has_many :cartitems
  has_many :orderitems
  # has_many :orders , through: :orderitems


end
