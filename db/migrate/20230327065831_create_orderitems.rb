class CreateOrderitems < ActiveRecord::Migration[7.0]
  def change
    create_table :orderitems do |t|
      t.integer :order_id
      t.integer :product_id
      t.decimal :quantity
      t.decimal :price

      t.timestamps
    end
  end
end
