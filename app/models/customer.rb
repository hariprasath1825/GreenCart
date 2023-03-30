class Customer < ApplicationRecord
  has_one :cart
  has_many :orders
  has_one :user , as: :accountable
  has_many :addresses , as: :addressable

end
