class ReviewController < ApplicationController

  before_action :check_customer_user

  def new
    @product = Product.find_by(id: params[:product_id])
    @review = Review.new
  end

  def create
    @review = Review.create(rating: params[:review][:rating] , comment: params[:review][:comment] , customer_id: current_user.accountable.id , product_id: params[:review][:product_id])
    @review.date = Date.today
    # p @review
    # byebug
    if @review.save
      flash[:notice] = "Review added successfully !"
      # redirect_to cart_order_index_path(id: params[:review][:id])
      redirect_to product_path(id: params[:review][:product_id])
    else
      flash[:notice]="Failed to post comment !"
      # redirect_to new_cart_order_review_path(product_id: params[:review][:product_id])
      render :new , status: :unprocessable_entity
    end

  end

  def destroy
    @review = Review.find_by(id: params[:id])
    if @review.nil?
      flash[:notice] = "Unauthorised action !"
      redirect_to product_index_path
    else
      if  @review.customer == current_user.accountable
        @review.delete
        flash[:notice] = "Review deleted successfully !"
        redirect_to product_path(id: @review.product.id)
      else
        flash[:notice] = "Unauthorized action !"
        redirect_to product_path(id: @review.product.id)
      end
    end
  end

  private
  def check_customer_user
    unless user_signed_in? and current_user.customer?
      flash[:notice] = "Unauthorized action !"
      redirect_to new_user_session_path
    end
  end
end