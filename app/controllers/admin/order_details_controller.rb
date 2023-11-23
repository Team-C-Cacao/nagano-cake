class Admin::OrderDetailsController < ApplicationController
  # 制作ステータスの更新
  def update
    @order_detail = OrderDetail.find(params[:id]) #特定の注文詳細を取得

    if @order_detail.update(order_detail_params)  #注文詳細の製作ステータスを更新
      update_order_status 
    end

    redirect_to admin_order_path(@order_detail.order), notice: "製作ステータスを更新しました" 
  end

  #　顧客の注文履歴表示
  def show
    @customer = Customer.find(params[:id])  #特定の顧客を取得
    @orders = @customer.orders  #顧客に関連する注文一覧を取得
  end


  private
  
  #　許可された注文詳細のパラメータのみを取得
  def order_detail_params
    params.require(:order_detail).permit(:making_status)
  end
  
  #　注文ステータスを更新
  def update_order_status
    @order = @order_detail.order #　注文詳細が属する注文する取得　
    @order_details = @order.order_details 　#　注文に関連する注文詳細一覧を取得

    if @order_detail.making_status == "製作中"
      @order.update(status: "製作中") #注文に関連する注文詳細一覧を取得
    end

    if @order_detail.making_status == "制作完了" && @order_details.all? { |detail| detail.making_status == "制作完了" }
      @order.update(status: "発送準備中") #注文ステータスを"制作中"に更新
    end
  end

end

