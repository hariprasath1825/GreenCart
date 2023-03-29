class AddColumnsToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products,:name,:string
    add_column :products,:price,:decimal
    add_column :products,:description,:text
    add_column :products,:seller_id,:integer
    add_column :products,:available_quantity,:decimal
    add_column :products,:category ,:string
  end
end
