class Api::CartsController < Api::ApiController

  before_action :doorkeeper_authorize!
  before_action :check_customer_user


  def index
    @cartitems = Cartitem.where(cart_id: current_user.accountable.cart.id)
    if @cartitems.empty?
      render json: "No products in Cart !" , status: 200
    else
      render json: @cartitems , status: 200
    end
  end


  def create
    @cartitem=Cartitem.new(cartitem_params)
    @product=Product.find_by(id: params[:cartitem][:product_id])
    if @product.nil?
      render json:{error: "No such product exists !"} , status: 404
    else
      @cartitem.price= @product.price.to_i * params[:cartitem][:quantity].to_i
      @cartitem.cart_id = current_user.accountable.cart.id

      if @cartitem.save
        render json: {message: "Product added to cart"} , status: 200
      else
        render json: {error: @cartitem.errors } , status: 422
        # puts @cartitem.errors.full_messages
      end
    end
  end


  def update
    @cart = Cart.find_by(id: params[:id])
    if @cart.nil?
      render json: {error: "No such cart id exists ! "} , status: 404
    else
      @cartitem=Cartitem.find_by(id: params[:cartitem][:id] , cart_id: current_user.accountable.cart.id)
      if @cartitem.nil?
        render json: { error: "No such product in cart !" } , status: 404
      else
        price= @cartitem.product.price * params[:cartitem][:quantity].to_i
        if @cartitem.update(quantity: params[:cartitem][:quantity], price: price)
          render json: @cartitem , status: 200
        else
          render json: {error:  "failed to update cartitem !" } , status: 422
        end
      end
    end
  end

  def destroy
    @cartitem=Cartitem.find_by(cart_id: params[:id] , id: params[:cartitem][:id])
    if @cartitem.nil?
      render json: {error: "Cart item not found !" } ,status: 404
    else
      @cartitem.destroy
      render json: {message: "Cart item destroyed successfully !" } ,status: 200
    end
  end


  private
  def cartitem_params
    params.require(:cartitem).permit( :product_id , :quantity)
  end

  def cartitem_update_params
    params.require(:cartitem).permit(:quantity)
  end

  def check_customer_user
    unless user_signed_in? and current_user.customer?
      render json: {error: "Unauthorized action !" }, status: 401
    end
  end

end
