class Order < ApplicationRecord

  belongs_to :customer
  has_many :orderitems
  # has_many :products , through: :orderitems
end
