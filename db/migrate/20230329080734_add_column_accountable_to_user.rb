class AddColumnAccountableToUser < ActiveRecord::Migration[7.0]
  def change
    add_reference :users , :accountable, polymorphic: true
  end
end
