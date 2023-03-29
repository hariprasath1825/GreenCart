class CustomerController < ApplicationController

  def index
    @products=Product.all.order(:id)
  end


end