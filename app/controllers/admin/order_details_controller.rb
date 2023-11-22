class Admin::OrderDetailsController < ApplicationController

  def update
    @order_detail = OrderDetail.find(params[:id])

    if @order_detail.update(order_detail_params)
      update_order_status
    end
    
    redirect_to admin_order_path(@order_detail.order), notice: "製作ステータスを更新しました"
  end

  def show
    @customer = Customer.find(params[:id])
    @orders = @customer.orders
  end
  
  
  private
  def order_detail_params
    params.require(:order_detail).permit(:making_status)
  end
  
  def update_order_status
    @order = @order_detail.order
    @order_details = @order.order_details

    if @order_detail.making_status == "製作中"
      @order.update(status: "製作中")
    end

    if @order_detail.making_status == "制作完了" && @order_details.all? { |detail| detail.making_status == "制作完了" }
      @order.update(status: "発送準備中")
    end
  end
  
end

