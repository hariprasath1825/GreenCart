class Cartitem < ApplicationRecord

  belongs_to :cart
  belongs_to :product

  validates :quantity, :price , :product_id , :cart_id , presence: true
  validates :quantity , comparison: {greater_than: 0 }

end
