class AddColumnsToProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :product,:name,:string
    add_column :product,:price,:decimal
    add_column :product,:description,:text
    add_column :product,:seller_id,:integer
    add_column :product,:available_quantity,:decimal
    add_column :product ,:category ,:string
  end
end
