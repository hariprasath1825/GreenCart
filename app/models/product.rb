class Product < ApplicationRecord
  belongs_to :seller
  has_many :cartitems , dependent: :destroy
  has_many :orderitems , dependent: :destroy
  has_many :reviews , dependent: :destroy
  has_one_attached :image , dependent: :destroy
  # has_many :orders , through: :orderitems

  validates :name, :price , :description , :available_quantity , :seller_id ,:category  , presence: true  # , :image
  validates :name , format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
  validates :price , comparison: {greater_than: 0}
  validates :description , length: {in: 10..100, wrong_length: "Description length should be within 10 to 100 characters !"}
  validates :available_quantity , numericality: true

end
