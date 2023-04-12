ActiveAdmin.register Product do


  permit_params :name, :price, :description, :seller_id, :available_quantity, :category


  index do
    selectable_column
    column :name do |product|
      link_to product.name , admin_product_path(id: product.id)
    end
    column :price
    column :available_quantity
    column :seller.name
    column :description
    column :category
    column :created_at
    column :updated_at
  end


  filter :name
  filter :seller
  filter :price
  filter :available_quantity
  filter :category
  # filter :rating



end
