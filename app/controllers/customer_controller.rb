class CustomerController < ApplicationController

  def index
    # @orders= Order.where(customer_id: current_user.accountable.id)
  end

  def show
    @customer = Customer.find_by(id: current_user.accountable.id)
    # @Orderitems= Orderitem.where(order_id: params[:order_id])
  end



end