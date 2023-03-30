class AddColumnAgeToCustomer < ActiveRecord::Migration[7.0]
  def change
    add_column :customers,:age ,:integer
    add_column :sellers , :age ,:integer
    remove_column :customers  , :address
  end
end
