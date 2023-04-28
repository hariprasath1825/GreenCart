class HomeController < ApplicationController

  def index
    @products = Product.all
    if user_signed_in?
      redirect_to product_index_path
    end
  end

  def log_out

  end
end