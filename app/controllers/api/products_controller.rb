class Api::ProductsController < Api::ApiController

  before_action :doorkeeper_authorize! , except: %i[all_products]
  before_action :check_seller_user ,only: %i[create update destroy]


  def index
    if current_user.customer?
      @products=Product.all
      render json:@products , status: 200
    elsif current_user.seller?
      @products = current_user.accountable.products
      render json:@products , status: 200
    else
      @products=Product.all
      render json: @products , status: 200
    end
  end


  def show
    @product=Product.find_by(id: params[:id])
    if @product.nil?
      render json: { error: "Product not found" } , status: 404
    else
      if current_user.seller?
        if @product.seller == current_user.accountable
        render json: @product , status: 200
        else
          render json: {error: "Forbidden action !"}, status: 403
        end
      else
        render json: @product , status: 200
      end
    end
  end


def create
  @product=Product.new(product_params)
  @product.seller_id = current_user.accountable.id
  if @product.save
    render json:@product  , status: 201
  else
    render json: {error: @product.errors.full_messages} , status: 422
  end
end


def update
  @product=Product.find_by(id: params[:id])
  if @product.nil?
    render json:{error: "Product not found !"} , status: 404
  else
    if current_user.accountable.id == @product.seller_id.to_i
      if @product.update(product_params)
        render json:@product , status: 200
      else
        render json: {error: @product.errors} , status: 422
      end
    else
      render json: {error: "Unauthorised to update this product !"} , status: 401
    end
  end
end


def destroy
  @product = Product.find(params[:id])
  if @product.nil?
    render json: {error: "Product not found " } , status: 404
  elsif @product.seller_id == current_user.accountable.id
    @product.destroy
    render json: { message: "Product destroyed successfully " }, status: 200
  else
    render json: {error: "Unauthorized to delete product ! "} , status: 401
  end
end


# custom action
def all_products
  @products=Product.all.where.not(available_quantity: 0)
  render json: @products , status: 200
end



private
def product_params
  params.require(:product).permit(:name,:price,:description,:available_quantity,:category)
end

def check_seller_user
  unless current_user.seller?
    render json: {error: "Unauthorized action  ! "} , status: 401
  end
end

end
