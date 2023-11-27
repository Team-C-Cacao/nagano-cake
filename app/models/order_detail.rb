class OrderDetail < ApplicationRecord

  enum making_status: { unable_to_start: 0, waiting_for_production: 1, in_production: 2, production_completed: 3 }

  belongs_to :item
  belongs_to :order
  

end
