class Api::ReviewsController < Api::ApiController


  def create
    if current_user.customer? and current_user.accountable.cart.id == params[:cart_id].to_i
      # byebug
      @order = Order.find_by(id: params[:order_id])
      if !@order.nil?
        if @order.customer_id == current_user.accountable.id
        @product = Product.find_by(id: params[:review][:product_id])
        if @order.products.include?(@product)
          @review = Review.new(rating: params[:review][:rating] , comment: params[:review][:comment] , customer_id: current_user.accountable.id , product_id:params[:review][:product_id])
          @review.date = Date.today
          if @review.save
            render json: @review , status: 200
            # puts current_user.role
          else
            render json: @review.errors , status: 422
          end
        else
          p "here"
          render json: {error: "No such product in this order ! "} ,status: 404
        end
      else
        render json: {error: "No such order id exists ! "} , status: 404
      end
    else
      render json: {error: "No such order id exists ! "} , status: 404
      end
    else
      render json: {error: "Unauthorized to write review ! "} , status: 401
    end
  end


end