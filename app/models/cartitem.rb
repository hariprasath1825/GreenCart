class Cartitem < ApplicationRecord

  belongs_to :cart
  belongs_to :product

  validates :quantity, :price , :product_id , :cart_id , presence: true
  validates :quantity , comparison: {greater_than: 0 }

  #callbacks
  before_validation :set_price
  before_update :set_updated_price




  private
  def set_price
    self.price=product.price * quantity
  end

  def set_updated_price
    price = product.price * quantity
  end

end
