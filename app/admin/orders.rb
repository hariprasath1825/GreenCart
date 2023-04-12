ActiveAdmin.register Order do

  permit_params :total_price, :customer_id, :payment_status, :order_date


  index do
    selectable_column
    column :id do |order|
      link_to order.id , admin_order_path(id: order.id)
    end
    column :total_price
    column :customer.name
    column :payment_status
    column :order_date
    column :created_at
    column :updated_at
  end



  filter :customer
  filter :payment
  filter :payment
  filter :total_price
  filter :order_date

end
