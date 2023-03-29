class CreateCartitems < ActiveRecord::Migration[7.0]
  def change
    create_table :cartitems do |t|
      t.integer "cart_id"
      t.integer "product_id"
      t.decimal "quantity"
      t.decimal "price"
      t.timestamps
    end
  end
end
