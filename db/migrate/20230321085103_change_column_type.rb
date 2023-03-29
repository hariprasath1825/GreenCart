class ChangeColumnType < ActiveRecord::Migration[7.0]
  def change
    change_column :sellers , :mbl_no ,:string
  end
end
