class ProductController < ApplicationController

  before_action :check_user
  before_action :check_seller_user , except: %i[index show]

  def index
    if current_user.role=="seller"
      @products=Product.where(seller_id: current_user.accountable.id).order(:id)
    else
      @q = Product.ransack(params[:q])
      @products=@q.result(distinct: true)
      # @products=Product.all.order(:id)
    end
  end

  def show
    @product=Product.find_by(id: params[:id])
    if @product.nil?
      flash[:notice] = "Unauthorised action !"
      redirect_to product_index_path
    else
      @reviews = Review.where(product_id: params[:id]).page params[:page]
      all_reviews = Review.where(product_id: params[:id])
      @avg_rating = 0
      unless all_reviews.empty?
        all_reviews.each do |r|
          @avg_rating += r.rating.to_i

        end
        @avg_rating = @avg_rating/all_reviews.count
      end
      if current_user.seller?
        if @product.seller_id != current_user.accountable.id
          flash[:notice] = "Unauthorised action !"
          redirect_to product_index_path
        end
      end
    end
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
    @product = Product.find_by(id: params[:id])
    unless !@product.nil? and @product.seller == current_user.accountable
      flash[:notice] = "Unauthorized action !"
      redirect_to product_index_path
    end
  end

  def update
    @product=Product.find_by(id: params[:id])
    if @product.seller_id == current_user.accountable.id
      if @product.update(product_params)
        flash[:notice]='Successfully updated the product !'
        redirect_to product_index_path
      else
        flash[:notice]='Failed to update product !'
        render :edit, status: :unprocessable_entity
        # redirect_to edit_product_path(id: @product.id)
      end
    else
      flash[:notice] = "Unauthorized action !"
      redirect_to product_index_path
    end
  end


  def destroy
    @product = Product.find_by(id: params[:id])
    if @product.seller_id == current_user.accountable.id
      @product.destroy
      flash[:notice]= 'Product deleted successfully !'
      redirect_to product_index_path
    else
      flash[:notice] = "Unauthorized action !"
      redirect_to product_index_path
    end
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
