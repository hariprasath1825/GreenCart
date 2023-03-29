class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string "name"
      t.decimal "price"
      t.text "description"
      t.integer "seller_id"
      t.decimal "available_quantity"
      t.string "category"
      t.timestamps
    end
  end
end