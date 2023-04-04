ActiveAdmin.register Product do


  permit_params :name, :price, :description, :seller_id, :available_quantity, :category


  index do
    selectable_column
    column :name
    column :price
    column :available_quantity
    column :description
    column :category
    column :created_at
    column :updated_at
    column :seller.name
  end


  filter :name
  filter :seller
  filter :price
  filter :available_quantity
  filter :category
  # filter :rating



end
