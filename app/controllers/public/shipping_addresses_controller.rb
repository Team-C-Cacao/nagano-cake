class Public::ShippingAddressesController < ApplicationController
  def index
    @shipping_addresses = ShippingAddress.where(customer: current_customer)
    @shipping_address = ShippingAddress.new
  end

  def create
      @shipping_address = ShippingAddress.new(shipping_address_params)
      @shipping_address.customer_id = current_customer.id
      if @shipping_address.save
        redirect_to request.referer, notice: "新規配送先を登録しました。"
      else
        @shipping_addresses = ShippingAddress.all
        render 'index'
      end
    end

  def destroy
    @shipping_address = ShippingAddress.find(params[:id])
    @shipping_address.destroy
    flash.now[:alert] = "配送先を削除しました"
    redirect_to shipping_addresses_path
  end

  def edit
    @shipping_address = ShippingAddress.find(params[:id])
  end


  def update
    @shipping_address = ShippingAddress.find(params[:id])
    if @shipping_address.update(shipping_address_params)
      redirect_to shipping_addresses_path, notice: "配達先を変更しました。"
    else
      render :edit
    end
  end

  private

  def shipping_address_params
    params.require(:shipping_address).permit(:postal_code, :shipping_address, :name)
  end

end