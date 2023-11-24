class Order < ApplicationRecord
  # 顧客を示すアソシエーション
  belongs_to :customer
  # 注文に関連する注文詳細が複数存在することを示すアソシエーション
  has_many :order_details
  # 支払い方法の種類を示すenum
  enum payment_method: { credit_card: 0, transfer: 1 }
  # 注文ステータスの種類を示すenum
  enum order_status: { waiting_for_payment: 0, payment_confirmation: 1, in_production: 2, preparation_for_shipping: 3, sent: 4 }

  validates :postal_code, presence: true
  validates :address, presence: true
  validates :name, presence: true

end
