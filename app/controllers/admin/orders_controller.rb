class Admin::OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details.all
     ary = []
    @order_details.each do |order_detail|
      ary << order_detail.including_tax_price * order_detail.amount
    end
    @order_detail_price = ary.sum
    @order.shipping = 800
    @order.total = @order.shipping + @order_detail_price
  end
  
  def update
    @order = Order.find(params[:id])
    @order_details = @order.order_details
    @order.update(order_params)
    redirect_to admin_order_path(@order), notice: "注文ステータスを変更しました"
  end
  
  
  private
  
  def order_params
    params.require(:order).permit(:order_status,:making_status)
  end
  
end
