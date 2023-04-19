class ProductController < ApplicationController

  before_action :check_user
  before_action :check_seller_user , except: %i[index show]

  def index
    if current_user.role=="seller"
    @products=Product.where(seller_id: current_user.accountable.id)
    else
      @products=Product.where.not(available_quantity: 0).order(:id)
    end
  end

  def show
    @product=Product.find_by(id: params[:id])
    @reviews = Review.where(product_id: params[:id])
  end

  def new
    @product=Product.new
  end
  def create
    @product=Product.new(product_params)
    @product.seller_id = current_user.accountable.id
    if @product.save
      flash[:notice] = 'Product saved successfully !'

      redirect_to product_index_path
    else
      flash[:notice] = 'Failed to save new product !'
      render :new , status: :unprocessable_entity
    end
  end

  def edit
    @product=Product.find(params[:id])
  end

  def update
    @product=Product.find_by(id: params[:id])
    if @product.update(product_params)
      flash[:notice]='Successfully updated the product !'

      redirect_to product_index_path
    else
      flash[:notice]='Failed to update product !'
      # redirect_to edit_product_path
      render :edit, status: :unprocessable_entity
    end
  end



  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    flash[:notice]= 'Product deleted successfully !'
    redirect_to product_index_path
  end


  private
  def product_params
    params.require(:product).permit(:name,:price,:description,:seller_id,:available_quantity,:category,:image)
  end

  def check_user
    unless user_signed_in?
      flash[:notice] = "Unauthorized action ! Please log in to continue ."
      redirect_to new_user_session_path
    end
  end

  def check_seller_user
    unless user_signed_in? and current_user.seller?
      flash[:notice] = "Unauthorized action ! Please log in to continue ."
      redirect_to new_user_session_path
    end
  end

end
