ActiveAdmin.register Cart do


  permit_params :customer_id, :total_price

  filter :customer
  filter :cartitems
  filter :total_price

end
