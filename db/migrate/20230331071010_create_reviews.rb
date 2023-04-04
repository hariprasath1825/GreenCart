class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.integer :customer_id
      t.text :comment
      t.integer :rating
      t.integer :product_id
      t.date :date

      t.timestamps
    end
  end
end
