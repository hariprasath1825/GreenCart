ActiveAdmin.register Seller do

  permit_params :name, :mbl_no, :age

  index do
    selectable_column
    column :id do |seller|
      link_to seller.id, admin_seller_path(id:seller.id)
    end
    column :name
    column 'Mobile',:mbl_no
    column :age
    column :created_at
    column :updated_at
  end


  filter :id
  filter :name
  filter :age
  filter :mbl_no ,label: "Mobile"

  scope :all
  scope :seller_with_product
  scope :seller_without_product


end
