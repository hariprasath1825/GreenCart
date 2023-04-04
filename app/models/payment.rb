class Payment < ApplicationRecord
  belongs_to :order

  validates :order_id , presence: true
  validates :paid_amount , presence: true , numericality: true
end
