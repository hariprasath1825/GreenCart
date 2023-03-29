class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :total_price
      t.integer :customer_id
      t.boolean :payment_status

      t.timestamps
    end
  end
end
