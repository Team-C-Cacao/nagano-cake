class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!, only: [:new, :confirm, :create, :index, :show, :complete]

  def new
    @order = Order.new
    @shipping_addresses = current_customer.shipping_addresses.all #customer_idに紐づいた登録済み配送先データ全件取得
  end

  def confirm
    @order = Order.new(order_params)
    @cart_items = CartItem.where(customer_id: current_customer.id) #cart_itemsに紐づいたcustomer_id取得

    ary = [] #空白のarray(配列)用意
    @cart_items.each do |cart_item| #cart_itemのデータを1件ずつ取り出す
      ary << cart_item.item.excluding_tax_price * 1.1 * cart_item.amount #各itemの税込価格*個数で小計を取得
    end
    @cart_items_price = ary.sum #上記の計算結果を合計し、商品合計価格を取得
    @order.shipping = 800 #shipping(送料)定義
    @order.total = @order.shipping + @cart_items_price #送料と商品合計を足して請求額を取得

    @order.payment_method = params[:order][:payment_method] #支払方法データ取得

    #お届け先データ取得
      # ご自身の住所であれば
    if params[:order][:address_option] == "0"
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name + current_customer.first_name

      # 登録済住所から選択であれば
    elsif params[:order][:address_option] == "1"
      if ship = ShippingAddress.find_by(id: params[:order][:address_id])
        @order.postal_code = ship.postal_code
        @order.address = ship.shipping_address
        @order.name = ship.name
      else
        flash.now[:alert] = "お届け先の住所が選択されていません。"
        @shipping_addresses = current_customer.shipping_addresses.all
        render 'new'
      end

      # 新規住所入力であれば
    elsif params[:order][:address_option] == "2"
      if params[:order][:postal_code].blank? || params[:order][:address].blank? || params[:order][:name].blank?
      flash.now[:alert] = "新しいお届け先が入力されていません。"
      render 'new'
      end

      @order.postal_code = params[:order][:postal_code]
      @order.address = params[:order][:address]
      @order.name = params[:order][:name]

    else
      flash.now[:alert] = "不正な操作が行われました。"
      render 'new'

    end

  end

  def create
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    @order.shipping = 800 #shipping(送料)定義
    @order.payment_method = params[:order][:payment_method] #支払方法データ取得

    if @order.save #保存されたら
    cart_items = CartItem.where(customer_id: current_customer.id)  # @cart_itemsをここで再定義
    # order_detailの保存
      cart_items.each do |cart_item| #カートの商品を1つずつ取り出しループ
        @order_detail = OrderDetail.new #初期化宣言
        @order_detail.item_id = cart_item.item_id #商品idを注文商品idに代入
        @order_detail.amount = cart_item.amount #商品の個数を注文商品の個数に代入
        @order_detail.including_tax_price = cart_item.item.tax_included_price.floor #tax_included_priceメソッドで税込価格を代入
        @order_detail.order_id =  @order.id #注文商品に注文idを紐付け
        @order_detail.save #注文商品を保存
        cart_item.destroy #カートの中身を削除
      end #ループ終わり
      redirect_to complete_orders_path #注文完了画面へ遷移
    else
      @cart_items = CartItem.where(customer_id: current_customer.id)
      @total_price = @cart_items.sum(&:subtotal)
      render 'cart_items/index', alert: "注文に失敗しました" #ショッピングカートへ戻る
    end

    #61行目のtax_included_priceはcart_itemモデルで定義されている
    #アソシエーションで結ばれたモデル内で定義されたメソッドはそのまま使用可能
    #コントローラー内で定義されている場合は関連付けがあっても再定義が必要

  end

  def complete
  end

  def index
    @orders = current_customer.orders.page(params[:page]).per(5) #注文履歴データ全件取得
  end

  def show
    @order = Order.find(params[:id]) #注文履歴データ1件取得
    @order_details = @order.order_details #注文詳細データ取得
  end

  private

  def order_params
    params.require(:order).permit(:shipping, :payment_method, :total, :order_status, :name, :postal_code, :address)
  end

end