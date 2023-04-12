class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :accountable , polymorphic: true
  validates :email , format: URI::MailTo::EMAIL_REGEXP

  def self.authenticate(email, password)
    user=User.find_for_authentication(email: email)
    user&.valid_password?(password)? user:nil
  end

  def seller?
    false
    true if role=="seller"
  end

  def customer?
    false
    true if role=="customer"
  end


end
