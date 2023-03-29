class Customer < ApplicationRecord
  has_one :cart
  has_many :orders
end
