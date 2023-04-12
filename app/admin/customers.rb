ActiveAdmin.register Customer do

  permit_params :name, :mbl_no, :age

  index do
    selectable_column
    column :id
    column :name
    column :mbl_no
    column :age
    column :created_at
    column :updated_at
  end

  filter :name
  filter :mbl_no
  filter :age
  filter :order
  filter :cart
  filter :addresses

  scope :all
  scope :made_purchases
  scope :no_purchases_made

end
