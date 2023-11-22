class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!, only: [:new, :confirm, :create, :index, :show, :complete]

  def new
    @order = Order.new
    @shipping_addresses = current_customer.shipping_addresses.all
  end

  def confirm
    @order = Order.new(order_params)
    @cart_items = CartItem.where(customer_id: current_customer.id)
    @order.payment_method = params[:order][:payment_method]
    ary = []
    @cart_items.each do |cart_item|
      ary << cart_item.item.excluding_tax_price * 1.1 * cart_item.amount
    end
    @cart_items_price = ary.sum
    @order.shipping = 800
    @order.total = @order.shipping + @cart_items_price

      # ご自身の住所であれば
    if params[:order][:address_option] == "0"
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name + current_customer.first_name

      # 登録済住所から選択であれば
    elsif params[:order][:address_option] == "1"
      ship = ShippingAddress.find(params[:order][:address_id])
      @order.postal_code = ship.postal_code
      @order.address = ship.shipping_address
      @order.name = ship.name

      # 新規住所入力であれば
    elsif params[:order][:address_option] = "2"
      @order.postal_code = params[:order][:postal_code]
      @order.address = params[:order][:address]
      @order.name = params[:order][:name]
    else
      render 'new'
    end

  end

  def create
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    @order.shipping = 800
    @order.payment_method = params[:order][:payment_method]

    if @order.save
    cart_items = CartItem.where(customer_id: current_customer.id)  # @cart_itemsをここで再定義
    # order_detailの保存
      cart_items.each do |cart_item| #カートの商品を1つずつ取り出しループ
        @order_detail = OrderDetail.new #初期化宣言
        @order_detail.item_id = cart_item.item_id #商品idを注文商品idに代入
        @order_detail.amount = cart_item.amount #商品の個数を注文商品の個数に代入
        @order_detail.including_tax_price = cart_item.item.tax_included_price.floor #消費税込みに計算して代入
        @order_detail.order_id =  @order.id #注文商品に注文idを紐付け
        @order_detail.save #注文商品を保存
        cart_item.destroy #カートの中身を削除
      end #ループ終わり
      redirect_to complete_orders_path
    else
      render :cart_items, alert: "注文に失敗しました"
    end

  end

  def complete
    @thanks = Item.where(is_active: true).order("RANDOM()").limit(3)
  end

  def index
    @orders = current_customer.orders.page(params[:page]).per(5)
  end

  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details
  end

  private

  def order_params
    params.require(:order).permit(:shipping, :payment_method, :total, :order_status, :name, :postal_code, :address)
  end

end