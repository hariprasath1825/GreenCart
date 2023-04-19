class CartController < ApplicationController

before_action :check_customer_user
  def index
    @cartitems = Cartitem.where(cart_id: current_user.accountable.cart.id)
  end

  def new
    @cartitem = Cartitem.new
  end

  def create

    @cartitem=Cartitem.new(cartitem_params)
    @cartitem.cart_id = current_user.accountable.cart.id

    if @cartitem.save
      flash[:notice] = 'Product added to cart successfully !'
      redirect_to   product_index_path
    else
      flash[:notice]='Failed to add product to cart !'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @cartitem=Cartitem.find(params[:id])
  end

  def update
    @cartitem=Cartitem.find(params[:id])
    if @cartitem.update(quantity: params[:cartitem][:quantity])
      flash[:notice]='Product updated successfully !'
      redirect_to cart_index_path
    else
      flash[:notice]="Failed to update product !"
      render :edit , status: :unprocessable_entity
    end
  end

  def destroy
    @cartitem=Cartitem.find(params[:id])
    @cartitem.destroy

    redirect_to cart_index_path

  end

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
