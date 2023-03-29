class CartController < ApplicationController

  def index
    @cartitems = Cartitem.all
  end

  def new(product_id: :product_id)
    @cartitem = Cartitem.new
    @cartitem.product_id=product_id
    end

  def create
    @cartitem=Cartitem.new(cartitem_params)
    @cartitem.price=params[:cartitem][:price].to_i*params[:cartitem][:quantity].to_i
    # p @caritems
    if @cartitem.save
      flash[:notice] = 'Product added to cart successfully !'
      redirect_to   product_index_path
    else
      flash[:notice]='Failed to add product to cart !'
      redirect_to new_cart_path
      # render :new, status: :unprocessable_entity
    end
  end

  def edit
    @cartitem=Cartitem.find(params[:id])
  end

  def update
    @cartitem=Cartitem.find(params[:id])
    price = @cartitem.price.to_i / @cartitem.quantity.to_i
    price = params[:cartitem][:quantity].to_i * price.to_i
    # p price
    if @cartitem.update(quantity: params[:cartitem][:quantity], price: price)
      flash[:notice]='Product updated successfully !'
      redirect_to cart_index_path
    else
      flash[:notice]="Failed to update product !"
      redirect_to cart_index_path
    end
  end

  def destroy
    @cartitem=Cartitem.find(params[:id])
    @cartitem.destroy

    redirect_to cart_index_path

  end

  private
  def cartitem_params
    params.require(:cartitem).permit(:cart_id, :product_id , :quantity)
  end

  def cartitem_update_params
    params.require(:cartitem).permit(:quantity)
  end

end
