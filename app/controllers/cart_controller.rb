class CartController < ApplicationController

  before_action :check_customer_user
  def index
    @cartitems = Cartitem.where(cart_id: current_user.accountable.cart.id)
  end

  def new
    @product = Product.find_by(id: params[:product_id])
    if @product.nil?
      flash[:notice]= "Unauthorized action !"
      redirect_to product_index_path
    else
      @cartitem = Cartitem.new
    end
  end

  def create
    if params[:cartitem][:quantity].to_i == 0
      flash[:notice] = "Quantity cannot be 0 !"
      redirect_to new_cart_path(product_id: params[:cartitem][:product_id])
    else
      cartitem = Cartitem.find_by(product_id: params[:cartitem][:product_id] ,cart_id: current_user.accountable.cart.id )
      if cartitem.nil?
        cartitem=Cartitem.new(cartitem_params)
        cartitem.cart_id = current_user.accountable.cart.id

        if cartitem.save
          flash[:notice] = 'Product added to cart successfully !'
          redirect_to   cart_index_path
        else
          flash[:notice]='Failed to add product to cart !'
          render :new, status: :unprocessable_entity
        end
      else
        quantity = cartitem.quantity + params[:cartitem][:quantity].to_i
        cartitem.update(quantity: quantity)
        flash[:notice] = 'Product added to cart successfully !'
        redirect_to   cart_index_path
      end
    end
  end

  def edit
    @cartitem=Cartitem.find_by(id: params[:id])
    if @cartitem.nil?
      flash[:notice] = "Unauthorized action !"
      redirect_to cart_index_path
    elsif @cartitem.cart_id != current_user.accountable.cart.id
      flash[:notice] = "Unauthorized action !"
      redirect_to cart_index_path
    end
  end

  def update
    @cartitem=Cartitem.find_by(id: params[:id])
    if @cartitem.cart_id == current_user.accountable.cart.id
      if @cartitem.update(quantity: params[:cartitem][:quantity])
        flash[:notice]='Product updated successfully !'
        redirect_to cart_index_path
      else
        flash[:notice]="Failed to update product !"
        render :edit , status: :unprocessable_entity
      end
    else
      flash[:notice] = "Unauthorized action !"
      redirect_to cart_index_path
    end
  end

  def destroy
    @cartitem=Cartitem.find_by(id: params[:id])
    if @cartitem.cart_id == current_user.accountable.cart.id
      @cartitem.destroy
      flash[:notice] = "Product removed from cart !"
      redirect_to cart_index_path
    else
      flash[:notice] = "Unauthorized action !"
      redirect_to cart_index_path
    end
  end

  # custom action
  # def clear_cart
  #   @cartitems = Cartitem.where(cart_id: current_user.accountable.cart.id)
  #   @cartitems.destroy!
  # end

  private
  def cartitem_params
    params.require(:cartitem).permit( :product_id , :quantity )
  end

  def cartitem_update_params
    params.require(:cartitem).permit(:quantity)
  end

  def check_customer_user
    unless user_signed_in? and current_user.customer?
      redirect_to new_user_session_path
    end
  end

end
