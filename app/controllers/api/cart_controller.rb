class Api::CartController < Api::ApiController


  def index
    if current_user.customer?
      @cart = Cart.find_by(id: current_user.accountable.cart.id)
      if @cart.nil?
        render json: { error: "No such cart id exists !" }  , status: 404
      else
        @cartitems = Cartitem.where(cart_id: current_user.accountable.cart.id)
        if @cartitems.empty?
          render json: "No products in Cart !"
        else
          render json: @cartitems , status: 200
        end
      end
    else
      render json: {error: "Unauthorized to view cart !"} , status: 401
    end
  end


  def create
    if current_user.customer?
      @cartitem=Cartitem.new(cartitem_params)
      @product=Product.find_by(id: params[:cartitem][:product_id])
      @cartitem.price= @product.price.to_i * params[:cartitem][:quantity].to_i
      @cartitem.cart_id = current_user.accountable.cart.id

      if @cartitem.save
        render json: {message: "Product added to cart"} , status: 200
      else
        render json: {error: @cartitem.errors } , status: 404
      end
    else
      render json: {error: "Unauthorized to add product to cart ! "} , status: 401
    end
  end


  def update
    if current_user.customer?
      @cart = Cart.find_by(id: params[:id])
      if @cart.nil?
        render json: {error: "No suct cart id exists ! "} , status: 404
      else
        @cartitem=Cartitem.find_by(id: params[:cartitem][:id] , cart_id: params[:id])
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
    else
      render json: {error: "Unauthorized to delete products in cart !"} , status: 401
    end
  end

  def destroy
    if current_user.customer?
      @cartitem=Cartitem.find_by(cart_id: params[:id] , id: params[:cartitem][:id])
      if @cartitem.nil?
        render json: {error: "Cart item not found !" } ,status: 404
      else
        @cartitem.destroy
        render json: {message: "Cart item destroyed successfully !" } ,status: 200
      end
    else
      render json: {error: "Unauthorized to remove product from cart ! "} , status: 401
    end
  end


  private
  def cartitem_params
    params.require(:cartitem).permit( :product_id , :quantity)
  end

  def cartitem_update_params
    params.require(:cartitem).permit(:quantity)
  end

end
