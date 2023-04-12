class PaymentController < ApplicationController

  def index
    @order=Order.find_by(id:params[:order_id])
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
