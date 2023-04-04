ActiveAdmin.register Order do

  permit_params :total_price, :customer_id, :payment_status, :order_date

  filter :customer
  filter :payment
  filter :payment
  filter :total_price
  filter :order_date

end
