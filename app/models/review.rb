class Review < ApplicationRecord

  belongs_to :customer
  belongs_to :product

  validates :date , :product_id , :rating , presence: true
  validates :rating , numericality: true

end
