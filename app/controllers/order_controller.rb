class OrderController < ApplicationController

    skip_before_action :verify_authenticity_token

  def  index
    @orderitems= Orderitem.where(order_id: params[:id])
     p @orders
  end


  def new
    @order = Order.new
  end


  def create
    price = 0
    @cartitems = Cartitem.where(cart_id: params[:cart_id])
    @cartitems.each do |cartitem|
      price += cartitem.price
    end
    # p price
    @order = Order.new(total_price: price, payment_status: 'false', order_date: Time.now.strftime("%d/%m/%Y"), customer_id: params[:customer_id])

    # p @order
    if @order.save
      # flash[:notice]= "Product ordered successfully !"

      @cartitems.each do |cartitem|
        orderitem = Orderitem.new(price: cartitem.price, quantity: cartitem.quantity ,product_id: cartitem.product.id,order_id: @order.id)
        orderitem.save
      end

      # @cartitems.destroy_all
      redirect_to cart_order_index_path(id: @order.id)
    else
      # flash[:notice]= "Product order failed  !"
      redirect_to new_product_order_path
    end
  end



    def show
      @orderitems= Orderitem.where(order_id: params[:id])
    end



    def order_history
      @orders= Order.where(customer_id: current_user.accountable.id)
    end


  def order_params
    params.require(:order).permit(:price)
  end


end
