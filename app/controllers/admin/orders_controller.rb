class Admin::OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details.all
  end
  
  def update
    @order = Order.find(params[:id])
    @order_details = @order.order_details
    if @order.update(order_params)
    end   
     redirect_to admin_order_path(@order), notice: "注文ステータスの変更しました"
  end
  
  
  private
  
  def order_params
    params.require(:order).permit(:order_status,:making_status)
  end
  
end
