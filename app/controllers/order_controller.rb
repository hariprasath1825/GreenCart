class OrderController < ApplicationController

  before_action :check_customer_user

  def  index
    @orderitems= Orderitem.where(order_id: params[:id])
  end

  def show
    @orderitems= Orderitem.where(order_id: params[:id])
  end

  def new
    @order = Order.new
  end


  def create
    price = 0
    @cartitems = Cartitem.where(cart_id: current_user.accountable.cart.id)      #params[:cart_id])
    @cartitems.each do |cartitem|
      price += cartitem.price
    end

    @order = Order.new(total_price: price, payment_status: 'false', order_date: Time.now.strftime("%d/%m/%Y"), customer_id: params[:customer_id])

    if @order.save
      @cartitems.each do |cartitem|
        orderitem = Orderitem.new(price: cartitem.price, quantity: cartitem.quantity ,product_id: cartitem.product.id,order_id: @order.id)
        orderitem.save
      end

      # @cartitems.destroy_all
      redirect_to cart_order_index_path(id: @order.id)
    else
      redirect_to new_product_order_path
    end
  end


  def order_history
    @orders= Order.where(customer_id: current_user.accountable.id)
  end


  private
  def order_params
    params.require(:order).permit(:price)
  end
  def check_customer_user
    unless user_signed_in? and current_user.customer?
      redirect_to new_user_session_path
    end
  end

end
