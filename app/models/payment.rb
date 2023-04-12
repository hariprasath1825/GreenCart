class Payment < ApplicationRecord
  belongs_to :order

  validates :order_id , presence: true
  validates :paid_amount , presence: true , numericality: true

  #callbacks
  after_create :change_payment_status
  after_save :update_available_quantity
  after_save :delete_cart



  private
  def change_payment_status
    order.update!(payment_status: "true")
  end
  def delete_cart
    order.customer.cart.cartitems.delete_all
  end
  def update_available_quantity
    cartitems=order.customer.cart.cartitems
    cartitems.each do|cartitem|
      updated_quantity=cartitem.product.available_quantity - cartitem.quantity
      cartitem.product.update!(available_quantity: updated_quantity)
    end
  end

end
