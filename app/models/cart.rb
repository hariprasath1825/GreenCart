class Cart < ApplicationRecord
  belongs_to :customer
  has_many :cartitems , dependent: :destroy
  has_many :products, through: :cartitems

  validates :total_price , :customer_id, presence: true , numericality: true



end
