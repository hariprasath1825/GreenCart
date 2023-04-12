class ReviewController < ApplicationController

  def new
    @product = Product.find_by(id: params[:product_id])
    @review = Review.new
  end

  def create
    @review = Review.create(rating: params[:review][:rating] , comment: params[:review][:comment] , customer_id: current_user.accountable.id , product_id:params[:review][:product_id])
    @review.date = Date.today
    p @review
    if @review.save
      flash[:notice] = "Review added successfully !"
      redirect_to cart_order_path(id: params[:review][:id])
  else
    flash[:notice]="Failed to post comment !"
    render :new , status: :unprocessable_entity
    end

  end


end
