class CustomerController < ApplicationController

  def index

  end

  def show
    @customer = Customer.find(params[:id])
  end

end