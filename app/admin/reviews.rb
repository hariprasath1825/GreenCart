ActiveAdmin.register Review do

  permit_params :customer_id, :comment, :rating, :product_id, :date

  filter :customer
  filter :product
  filter :rating
  filter :comment
  filter :date

end
