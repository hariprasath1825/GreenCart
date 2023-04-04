class ProductController < ApplicationController
  def index
    if current_user.role=="seller"
    @products=Product.where(seller_id: current_user.accountable.id)
    else
      @products=Product.all
    end
  end

  def show
    @product=Product.find(params[:id])
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
    @product=Product.find(params[:id])
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

end
