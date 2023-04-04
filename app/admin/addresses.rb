ActiveAdmin.register Address do

  permit_params :door_no, :street, :district, :state, :pincode, :addressable_id, :addressable_type

  filter :addressable_type
  filter :door_no
  filter :street
  filter :district
  filter :state
  filter :pincode
  filter :created_at

end
