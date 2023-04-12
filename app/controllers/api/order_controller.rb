class Api::OrderController < Api::ApiController


  # def  index
  #   @orderitems= Orderitem.where(order_id: params[:id])
  #   render json: @orderitems , status: 200
  # end


  def create
    if current_user.customer?
      price = 0
      @cartitems = current_user.accountable.cart.cartitems
      if @cartitems.empty?
        render json: { message: "Cart is empty ! " } , status: 400
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
        @cartitems.delete
        render json: @order, status:200
      else
        render json:@order.errors
      end
    end
    else
      render json: {error: "Unauthorized to create order ! "} ,status: 401
      end
  end


    def show
      @orderitems= Orderitem.where(order_id: params[:id])
      if @orderitems.nil?
        render json: "No such Order id exists !" , status: 404
      else
        render json: @orderitems , status: 200
      end
    end


# custom action
  def order_history
    if current_user.customer?
      @orders= Order.where(customer_id: current_user.accountable.id)
      if @orders.nil?
        render json: "No orders made ! " , status: 200
      else
        render json: @orders , status: 200
      end
    else
      render json: {error: "Unauthorized to access order history ! "} ,status: 401
    end
  end


  def order_params
    params.require(:order).permit(:price)
  end

end
