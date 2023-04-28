class Api::PaymentsController < Api::ApiController

  before_action :check_user

  def index
    @order=Order.find_by(id:params[:order_id])
    render json: @order
  end


  def create
    if current_user.accountable.cart.id == params[:cart_id].to_i
      @order = Order.find_by(id: params[:order_id])
      if current_user.accountable.orders.include?(@order)
        if params[:payment][:paid_amount].to_i == @order.total_price

          @payment=Payment.new(order_id: params[:order_id] , paid_amount: params[:payment][:paid_amount].to_i)
          if @payment.save
            render json: @payment , status: 200
          else
            render json: @payment.errors , status: 400
          end
        else
          render json: {error: "Total price of the bill is #{@order.total_price} rupees !" } , status: 422
        end
      else
        render json: {error: "No such order id exists ! "} , status: 404
      end
    else
      render json: {error: "Unauthorised action !"} , status: 401
    end
  end

  private
  def check_user
    unless current_user.customer?
      render json: {error: "Unauthorized to access this page ! "} ,status: 401
    end
  end

end
