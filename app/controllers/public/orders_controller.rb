class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!, only: [:new, :confirm, :create, :index, :show, :complete]

  def new
    @order = Order.new
    @shipping_addresses = current_customer.shipping_addresses.all
  end

  def confirm
    @order = Order.new(order_params)
    @cart_items = CartItem.where(customer_id: current_customer.id)
    #@order.payment_method = params[:order][:payment_method]
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
    # 参考サイト2
    @order = Order.new
    @order.customer_id = current_customer.id
    @order.shipping = 800

    @cart_items = CartItem.where(customer_id: current_customer.id)  # @cart_itemsをここで再定義

    ary = []
    @cart_items.each do |cart_item|
      ary << cart_item.item.excluding_tax_price * 1.1 * cart_item.amount
    end
    @cart_items_price = ary.sum
    @order.total = @order.shipping + @cart_items_price
    @order.save

    # order_detailの保存
    current_customer.cart_items.each do |cart_item| #カートの商品を1つずつ取り出しループ
      @order_detail = OrderDetail.new #初期化宣言
      @order_detail.item_id = cart_item.item_id #商品idを注文商品idに代入
      @order_detail.amount = cart_item.amount #商品の個数を注文商品の個数に代入
      @order_detail.tax_included_price = (cart_item.item.price * 1.1).floor #消費税込みに計算して代入
      @order_detail.order_id =  @order.id #注文商品に注文idを紐付け
      @order_detail.save #注文商品を保存
    end #ループ終わり

    current_customer.cart_items.destroy_all #カートの中身を削除
    redirect_to orders_path

    # 参考サイト1
    # @cart_items = CartItem.where(customer_id: current_customer.id)
    # ary = []
    # @cart_items.each do |cart_item|
    #   ary << cart_item.item.excluding_tax_price * 1.1 * cart_item.amount
    # end
    # @cart_items_price = ary.sum
    # @order.total = @order.shipping + @cart_items_price
    # @order.payment_method = params[:order][:payment_method]
    # if @order.payment_method == "credit_card"
    #   @order.order_status = 1
    # else
    #   @order.order_status = 0
    # end

    #   if @order.save
    #     if @order.order_status == 0
    #       @cart_items.each do |cart_item|
    #         OrderDetail.create!(order_id: @order.id, item_id: cart_item.item.id, price: cart_item.item.excluding_tax_price, amount: cart_item.amount, order_status: 0)
    #       end
    #     else
    #       @cart_items.each do |cart_item|
    #         OrderDetail.create!(order_id: @order.id, item_id: cart_item.item.id, price: cart_item.item.excluding_tax_price, amount: cart_item.amount, order_status: 1)
    #       end
    #     end
    #     @cart_items.destroy_all
    #     redirect_to complete_orders_path
    #   else
    #     render :items
    #   end
  end

  def complete
  end

  def index
    @orders = Order.all.page(params[:page]).per(5)
  end

  def show
    @order = Order.find(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:shipping, :payment_method, :total, :order_status, :name, :postal_code, :address)
  end

end