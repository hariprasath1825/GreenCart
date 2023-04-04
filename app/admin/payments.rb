ActiveAdmin.register Payment do

  permit_params :order_id, :paid_amount

  filter :order
  filter :paid_amount

end
