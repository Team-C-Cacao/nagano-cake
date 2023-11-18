class Order < ApplicationRecord

  belongs_to :customer
  has_many :order_details

  enum payment_methods: { credit_card: 0, transfer: 1 }
  enum order_status: { waiting_for_payment: 0, payment_confirmation: 1, in_production: 2, preparation_for_shipping: 3, sent: 4 }

  def self.payment_methods_i18n
    {
      credit_card: I18n.t('enums.order.payment_methods.credit_card'),
      transfer: I18n.t('enums.order.payment_methods.transfer')
    }
  end

end
