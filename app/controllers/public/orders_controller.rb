class Public::OrdersController < ApplicationController
  before_action :authenticate_member!, only: [:new, :confirm, :create, :indexm :show, :complete]
  
  def new
  end

  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      flash[:notice] = "注文が完了しました"
      redirect_to complete_order_path(@order)
    else
      render :new
    end
  end

  def confirm
    @order = Order.find(params[:id])
    @cart_items = CartItems.all
  end

  def complete
  end

  private

  def order_params
    params.require(:order).permit(:shipping, :payment_method, :total, :order_status, :name, :postal_code, :address)
  end

end
