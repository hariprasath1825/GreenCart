class ChangeDatatypeInOrder < ActiveRecord::Migration[7.0]
  def change
    change_column :orders , :total_price,  :decimal
    change_column :orders , :payment_status,  :string
    add_column :orders , :order_date , :date
  end
end
