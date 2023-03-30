class Seller < ApplicationRecord
  has_many :products
  has_one :user , as: :accountable
  has_many :addresses , as: :addressable

end
