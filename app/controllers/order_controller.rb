class OrderController < ApplicationController

  before_action :check_customer_user

  def  index
    order = Order.find_by(id: params[:id])
    if order.nil? or order.customer_id !=current_user.accountable.id or current_user.accountable.cart.id != params[:cart_id].to_i
      flash[:notice] = "Unauthorized action !"
      redirect_to root_path
    else
      @orderitems= Orderitem.where(order_id: params[:id])
    end
  end

  def show
    order = Order.find_by(id: params[:id])
    if order.nil? or order.customer_id !=current_user.accountable.id or current_user.accountable.cart.id != params[:cart_id].to_i
      flash[:notice] = "Unauthorized action !"
      redirect_to root_path
    else
      @orderitems= Orderitem.where(order_id: params[:id])
    end
  end

  def new
    @order = Order.new
  end


  def create
    price = 0
    @cartitems = Cartitem.where(cart_id: current_user.accountable.cart.id)  # params[:cart_id])
    if @cartitems.empty?
      flash[:notice] = "No products in cart !"
      redirect_to product_index_path
    else
      @cartitems.each do |cartitem|
        price += cartitem.price
      end

      @order = Order.new(total_price: price, payment_status: 'false', order_date: Time.now.strftime("%d/%m/%Y"), customer_id: current_user.accountable.id)
      if @order.save
        @cartitems.each do |cartitem|
          orderitem = Orderitem.new(price: cartitem.price, quantity: cartitem.quantity ,product_id: cartitem.product.id,order_id: @order.id)
          orderitem.save
        end
        # @cartitems.destroy_all
        redirect_to cart_order_index_path(id: @order.id)
      else
        flash[:notice] = "An error occurred while placing order !"
        render :new
      end
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
