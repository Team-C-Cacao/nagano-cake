class Public::OdersController < ApplicationController
  def new
  end

  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
  end

  def confirm
  end

  def complete
  end

  private

  def order_params
    params.require(:order).permit(:shipping, :payment_method, :total, :order_status, :name, :postal_code, :address)
  end

end
