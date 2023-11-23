class Admin::OrderDetailsController < ApplicationController
  # 制作ステータスの更新
  def update
    @order_detail = OrderDetail.find(params[:id]) #特定の注文詳細を取得
    @order = @order_detail.order #注文を取得
    @order_details = @order.order_details.all #注文に紐づく全ての注文詳細を取得
    
    #制作ステータスの更新が成功したかどうかのフラグ
    is_updated = true
    #注文詳細の製作ステータスを更新
    if@order_detail.update(order_detail_params) 
      # 製作ステータスが "製作中" の場合、注文のステータスを更新
      @order.update(order_status: "preparation_for_shipping") if @order_detail.making_status == "in_production"
      
      # すべての注文詳細の製作ステータスが "製作完了" であるか確認
      @order_details.each do |order_detail|  
      if order_detail.making_status != "production_completed"
        is_update =false # フラグを false に設定
      end
    end  
      # すべての注文詳細の製作ステータスが "製作完了" の場合、注文のステータスを更新
    @order.update(order_status: "preparation_for_shipping") if is_updated
    end
    redirect_to admin_order_path(@order_detail.order), notice: "製作ステータスを更新しました" #注文詳細が属する注文の詳細ページにリダイレクト 
  end

  # 顧客の注文履歴表示
  def show
    @customer = Customer.find(params[:id])  #特定の顧客を取得
    @orders = @customer.orders  #顧客に関連する注文一覧を取得
  end


  private
  
  # 許可された注文詳細のパラメータのみを取得
  def order_detail_params
    params.require(:order_detail).permit(:making_status)
  end
  
  # 注文ステータスを更新
  def update_order_status
    @order = @order_detail.order  #注文詳細が属する注文する取得
    @order_details = @order.order_details  #注文に関連する注文詳細一覧を取得

    if @order_detail.making_status == "製作中"
      @order.update(status: "製作中") #注文ステータスを"製作中"に更新
    end

    if @order_detail.making_status == "制作完了" && @order_details.all? { |detail| detail.making_status == "制作完了" }
      @order.update(status: "発送準備中") #注文ステータスを"発送準備中"に更新
    end
  end

end
