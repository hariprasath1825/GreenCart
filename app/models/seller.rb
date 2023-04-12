class Seller < ApplicationRecord

  has_many :products , dependent: :destroy
  has_one :user , as: :accountable , dependent: :destroy
  has_many :addresses , as: :addressable , dependent: :destroy


  validates  :name , :mbl_no , :age , presence: true
  validates :mbl_no , length: {is: 10} , numericality: { only_integer: true }
  validates :age , comparison: {greater_than: 17 , lesser_than: 100}
  # validates :name , format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }


  scope :seller_with_product, -> {where('id IN (?)',Array.wrap(Product.distinct(:seller_id).pluck(:seller_id)))}
  scope :seller_without_product , -> {where('id NOT IN (?)', Array.wrap(Product.distinct(:seller_id).pluck(:seller_id)))}

end