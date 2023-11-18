class CartItem < ApplicationRecord

  belongs_to :customer
  belongs_to :item

  def tax_included_price
    item.excluding_tax_price * 1.10
  end

  def subtotal
    tax_included_price * amount
  end

  def total_price
    cart_items.sum(&:subtotal)
  end

end
