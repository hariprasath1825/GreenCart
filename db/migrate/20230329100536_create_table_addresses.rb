class CreateTableAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string "door_no"
      t.string "street"
      t.string "district"
      t.string "state"
      t.integer "pincode"
      t.integer "addressable_id"
      t.string "addressable_type"
      t.timestamps
    end
  end
end
