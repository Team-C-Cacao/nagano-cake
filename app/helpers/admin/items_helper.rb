module Admin::ItemsHelper
  def display_including_tax_price(excluding_tax_price, tax_rate)
    including_tax_price = excluding_tax_price * (1 + tax_rate)
    including_tax_price
  end
end
