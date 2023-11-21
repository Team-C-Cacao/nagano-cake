class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         validates :last_name,presence: true
         validates :first_name,presence: true
         validates :last_name_kana,presence: true
         validates :first_name_kana,presence: true
         validates :postal_code,presence: true
         validates :address,presence: true
         validates :phone_number,presence: true

  has_many :orders
  has_many :cart_items
  has_many :shipping_addresses
  
  def self.looks(search, word)
    if search == "perfect_match"
      @customer = Customer.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @customer = Customer.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @customer = Customer.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @customer = Customer.where("title LIKE?","%#{word}%")
    else
      @customer = Customer.all
    end
  end

end
