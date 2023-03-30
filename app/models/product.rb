class Product < ApplicationRecord
  belongs_to :seller
  has_many :cartitems
  has_many :orderitems
  # has_many :orders , through: :orderitems


end
