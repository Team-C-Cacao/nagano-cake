class Public::ShippingAddressesController < ApplicationController
  def index
    @shipping_addresses = ShippingAddress.all
    @shipping_address = ShippingAddress.new
  end
  
  def create
      @shipping_address = ShippingAddress.new(shipping_addresses_params)
      @shipping_address.customer_id = current_customer.id
      if @shipping_address.save
        redirect_to 'shipping_addresses', notice: "新規配送先を登録しました。" 
      else
        @shipping_address = ShippingAddress.all
        render 'index'
      end
    end

  def destroy
    @shipping_address= ShippingAddress.find(params[:id])
    @shipping_address= current_customer.shippingaddress
    flash.now[:alert] = "配送先を削除しました"
    redirect_to shipping_addresses_path
  end
  
  def edit
    @shipping_address = ShippingAddress.find(params[:id])
  end
  
  
  def update
    @shipping_address = ShippingAddresses.find(params[:id])
    if @shipping_address.update(shipping_addresses_params)
      redirect_to shipping_addresses_path, notice: "配達先を変更しました。"
    else
      render :edit
    end
  end

  private

  def shipping_addresses_params
    params.require(:shipping_address).permit(:postal_code, :shipping_addresses, :name)
  end

end