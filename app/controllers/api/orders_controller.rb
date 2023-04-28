class Api::OrdersController < Api::ApiController

  before_action :check_customer_user

  def  index
    if current_user.accountable.cart.id == params[:cart_id].to_i
      @orderitems= Orderitem.where(order_id: params[:id])
      if @orderitems.empty?
        render json: {error: "No such order exists !"} , status: 422
      else
        render json: @orderitems , status: 200
      end
    else
      render json: "Unauthorized action !" , status: 401
    end
  end

  def show
    if current_user.accountable.cart.id == params[:cart_id].to_i
      @orderitems= Orderitem.where(order_id: params[:id])
      if @orderitems.empty?
        render json: "No such order exists !" , status: 404
      else
        render json: @orderitems , status: 200
      end
    else
      render json: "Unauthorized action !" , status: 401
    end
  end

  def create
    if current_user.accountable.cart.id == params[:cart_id].to_i
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
          @cartitems.delete_all
          render json: @order, status:200
        else
          render json:@order.errors , status: 422
        end
      end
    else
      render json: "Unauthorized action !" , status: 401
    end
  end




  # custom action
  def order_history
    @orders= Order.where(customer_id: current_user.accountable.id)
    if @orders.nil?
      render json: "No orders made ! " , status: 200
    else
      render json: @orders , status: 200
    end
  end

  private
  def order_params
    params.require(:order).permit(:price)
  end

  def check_customer_user
    unless current_user.customer?
      render json: "Unauthorized action !" , status: 401
    end
  end

end
