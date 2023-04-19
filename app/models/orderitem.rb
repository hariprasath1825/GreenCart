class Orderitem < ApplicationRecord

  belongs_to :order
  belongs_to :product

  validates :quantity, :price , :product_id , presence: true
  validates :quantity ,numericality: true , comparison: {greater_than: 0 }
  validates :price ,numericality: true , comparison: {greater_than: 0 }

end
