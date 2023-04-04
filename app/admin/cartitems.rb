ActiveAdmin.register Cartitem do

  permit_params :cart_id, :product_id, :quantity, :price

  filter :cart_id
  filter :product
  filter :quantity
  filter :price

end
