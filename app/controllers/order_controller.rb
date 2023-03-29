class OrderController < ApplicationController

  def  index
    @order=Order.all
  end

  def new
    @order = Order.new(order_params)
  end
  def create
    @order = Order.new(price: params[:price])
    @order.payment_status = true
    # @order.save
    #
    # current_user.cart.cart_items.each do |item|
    #   @order.orderitems.create(product_id: item.product_id, quantity: item.quantity, price: item.price)
    # end

    p @order
    if @order.save
      redirected_to cart_index_path
    else
      redirected_to new_product_order_path
    end
  end

  def order_params
    params.require(:order).permit(:price)
  end
end
