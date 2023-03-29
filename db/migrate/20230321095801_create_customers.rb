class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string "name"
      t.string "mbl_no"
      t.text "address"
      t.timestamps
    end
  end
end
