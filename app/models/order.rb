class Order < ApplicationRecord

  belongs_to :customer
  has_many :orderitems , dependent: :destroy
  has_many :products , through: :orderitems
  has_one :payment , dependent: :destroy


  validates :total_price ,:customer_id , :order_date , presence: true


end
