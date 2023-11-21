class ShippingAddress < ApplicationRecord

  belongs_to :customer
  validates :name, presence: true
  validates :shipping_address, presence: true
  validates :postal_code, presence: true

  def full_shipping_address
  '〒' + postal_code + ' ' + shipping_address + ' ' + name
  end

end
