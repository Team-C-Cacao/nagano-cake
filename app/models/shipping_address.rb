class ShippingAddress < ApplicationRecord
  # 顧客を示すアソシエーション
  belongs_to :customer
  # バリデーション
  validates :name, presence: true
  validates :shipping_address, presence: true
  validates :postal_code, presence: true

#注文の配送先情報を整形して文字列とする。郵便番号、配送先、および名前を結合して「〒[郵便番号] [配送先] [名前]」の形式で表示
  def full_shipping_address
  '〒' + postal_code + ' ' + shipping_address + ' ' + name
  end

end
