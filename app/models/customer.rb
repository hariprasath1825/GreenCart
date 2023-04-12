class Customer < ApplicationRecord


  has_one :cart , dependent: :destroy
  has_many :orders , dependent: :destroy
  has_one :user , as: :accountable , dependent: :destroy
  has_many :addresses , as: :addressable , dependent: :destroy
  has_many :reviews , dependent: :destroy


  validates  :name , :mbl_no , :age , presence: true
  validates :mbl_no , length: {is: 10} , numericality: { only_integer: true }
  validates :age , comparison: {greater_than: 17 , lesser_than: 100}
  validates :name , format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }


  scope :made_purchases , -> { joins(:orders).group('customers.id').having('count(customer_id) > 0') }
  scope :no_purchases_made , -> { Customer.where('id NOT IN (?)', Array.wrap(Order.distinct(:customer_id).pluck(:customer_id))) }


end
