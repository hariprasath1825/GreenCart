class PaymentController < ApplicationController

  def index
    @order=Order.find_by(id:params[:order_id])
    if @order.nil? or @order.customer_id != current_user.accountable.id or current_user.accountable.cart.id != params[:cart_id].to_i
      flash[:notice] = "Unauthorized action !"
      redirect_to root_path
    end
  end


  def create
    @payment=Payment.new(order_id: params[:order_id],paid_amount: params[:total_price])
    if @payment.save
      flash[:notice]="Purchase successful !"
      redirect_to cart_index_path

    else
      flash[:notice] = "Payment failed !"
      redirect_to cart_index_path
    end
  end

end
