class Api::ProductController < Api::ApiController

  before_action :doorkeeper_authorize! , except: %i[show]
  before_action :check_user ,only: %i[create update destroy]


  def index
    if user_signed_in?
      if current_user.customer?
        @products=Product.all.where.not(available_quantity: 0)
        render json:@products , status: 200
      else
        @products = current_user.accountable.products
        render json:@products , status: 200
      end
    else
      @products=Product.all.where.not(available_quantity: 0)
      render json: @products , status: 200
    end
  end


  def show
    @product=Product.find_by(id: params[:id])
    if @product.nil?
      render json: { error: "Product not found" } , status: 404
    else
      render json: @product , status: 200
    end
  end


  def create
      @product=Product.new(product_params)
      @product.seller_id = current_user.accountable.id
      if @product.save
        render json:@product  , status: 201
      else
        render json: {error: @product.errors} , status: 400
      end
  end


  def update
      @product=Product.find(params[:id])
      if @product.update(product_params)
        render json:@product , status: 200
      else
        render json: {error: @product.errors} , status: 422
      end
  end


  def destroy
    @product = Product.find_by(id: params[:id])
    if @product.seller_id == current_user.accountable.id
      if @product.nil?
        render json: {error: "Product not found " } , status: 404
      else
        @product.destroy
        render json: { message: "Product destroyed successfully " }, status: 200
      end
    else
      render json: {error: "Unauthorized to delete product ! "} , status: 401
    end
  end


  # custom action
  def all_products
    @products=Product.all
    render json: @products , status: 200
  end



  private
  def product_params
    params.require(:product).permit(:name,:price,:description,:available_quantity,:category)
  end

  def check_user
    unless current_user.seller?
      render json: {error: "Unauthorized to access this page ! "} , status: 401
    end
  end

end