class AddColumnsToSeller < ActiveRecord::Migration[7.0]
  def change
    add_column :sellers ,:name ,:string
    add_column :sellers , :mbl_no ,:integer
  end
end
