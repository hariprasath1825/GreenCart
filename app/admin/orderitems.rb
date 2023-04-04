ActiveAdmin.register Orderitem do

  permit_params :order_id, :product_id, :quantity, :price


  filter :order_id
  filter :product
  filter :quantity
  filter :price

end
