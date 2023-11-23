class Admin::OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id]) #特定の注文を取得
    @order_details = @order.order_details.all #注文に関連する注文詳細を取得

    #各注文詳細の価格 個数を計算して合計金額を求める
    #ary は計算された金額を格納するための配列
    #order_detail.including_tax_price * order_detail.amount 特定の order_detail の金額合計（税込み価格 * 個数）
     ary = []
    @order_details.each do |order_detail|
      ary << order_detail.including_tax_price * order_detail.amount
    end
    @order_detail_price = ary.sum
    #　注文に送料と合計金額を追加
    @order.shipping = 800
    @order.total = @order.shipping + @order_detail_price
  end

  #　注文ステータスの更新
  def update
    @order = Order.find(params[:id]) #特定の注文を取得
    @order_details = @order.order_details #注文に関連する注文詳細を取得
    @order.update(order_params) #注文ステータスの更新
    redirect_to admin_order_path(@order), notice: "注文ステータスを変更しました"
  end


  private


  #　許可された注文パラメータのみを取得
  def order_params
    params.require(:order).permit(:order_status,:making_status)
  end

end
