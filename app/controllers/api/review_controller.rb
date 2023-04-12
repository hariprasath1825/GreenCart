class Api::ReviewController < Api::ApiController


  def create
    if current_user.customer? and current_user.accountable.cart.id == params[:cart_id].to_i
      @order = Order.find_by(id: params[:order_id])
      if @order.customer_id == current_user.accountable.id
        @product = Product.find_by(id: params[:review][:product_id])
        if @order.products.include?(@product)
          @review = Review.new(rating: params[:review][:rating] , comment: params[:review][:comment] , customer_id: current_user.accountable.id , product_id:params[:review][:product_id])
          @review.date = Date.today
          if @review.save
            render json: @review
          else
            render json: @review.errors
          end
        else
          render json: {error: "No such product in this order ! "} ,status: 404
        end
      else
        render json: {error: "No such order id exists ! "} , status: 404
      end
    else
      render json: {error: "Unauthorized to write review ! "} , status: 401
    end
  end


end