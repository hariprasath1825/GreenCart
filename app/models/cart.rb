class Cart < ApplicationRecord
  belongs_to :customer
  has_many :cartitems , dependent: :destroy
  has_many :products, through: :cartitems

  validates :total_price ,  presence: true
  validates :total_price , numericality: true
  validates :total_price , comparison: {greater_than: -1}



end
