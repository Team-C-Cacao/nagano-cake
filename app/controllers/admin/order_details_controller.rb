class Admin::OrderDetailsController < ApplicationController

  def update
    @order_detail = OrderDetail.find(params[:id])
    @order = @order_detail.order
    @order_details = @order.order_details.all
    
    is_updated = true
    if @order_detail.update(order_detail_params)
        @order.update(status: "製作中") if @order_detail.making_status == "製作中"
        @order_details.each do |order_detail|
          if order_detail.making_status != "製作完了"
            is_update = false
          end
        end 
        @order.update(status: "発送準備中") if is_update  
    end
        redirect_to admin_order_path(@order)
  end
end 

  def show
    @customer = Customer.find(params[:id])
    @orders = @customer.orders
  end
end
