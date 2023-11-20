class Admin::OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
  end
  
  # def update
    #@order = order.find(params[:id])
    #if @order.update(order_params)
     # redirect_to order_path(@order), notice: "注文ステータスの変更しました"
    #else
     # render :edit
    #end
  #end
  
end
