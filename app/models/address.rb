class Address < ApplicationRecord

  belongs_to :addressable , polymorphic: true

  validates :door_no , :street , :district , :state , :pincode , presence: true
  validates :pincode , length: {is: 6} , numericality: { only_integer: true }
  validates :district , :state , format: { with: /\A[a-z A-Z]+\z/, message: "only allows aplhabets" }

end
