class Review < ApplicationRecord

  paginates_per 2

  belongs_to :customer
  belongs_to :product

  validates :date , :product_id , :customer_id , :rating , presence: true
  validates :rating , numericality: true , comparison: { greater_than: -1 , less_than: 6 }
end
