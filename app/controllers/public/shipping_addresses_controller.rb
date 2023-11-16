class Public::ShippingAddressesController < ApplicationController
  def index
    @shipping_addresses = @shipping_addresses = ShippingAddress.all 
  end

  def edit
  end
end
