class Order < ApplicationRecord





  enum payment_method: { credit_card: 0, transfer: 1 }
  enum order_status: { waiting_for_payment: 0, payment_confirmation: 1, in_production: 2, preparation_for_shipping: 3, sent: 4 }
end
