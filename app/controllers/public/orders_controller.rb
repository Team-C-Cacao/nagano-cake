class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!, only: [:new, :confirm, :create, :index, :show, :complete]

  def new
    @order = Order.new
  end

  def confirm
    @order = Order.new(order_params)
    @cart_items = CartItem.where(customer_id: current_customer.id)
    @payment_method = params[:order][:payment_method]

    ary = []
    @cart_items.each do |cart_item|
      ary << cart_item.item.excluding_tax_price * 1.1 * cart_item.amount
    end
    @cart_items_price = ary.sum
    @order.shipping = 800
    @total = @order.shipping + @cart_items_price

    if params[:order][:address_option] == "0"
      @order.new_postal_code = current_customer.postal_code
      @order.new_address = current_customer.address
      @order.new_name = current_customer.last_name + current_customer.first_name

      # collection.selectであれば
    elsif params[:order][:address_option] == "1"
      ship = Address.find(params[:order][:customer_id])
      @order.new_postal_code = ship.postal_code
      @order.new_address = ship.address
      @order.new_name = ship.name

      # 新規住所入力であれば
    elsif params[:order][:address_option] = "2"
      @order.new_postal_code = params[:order][:new_postal_code]
      @order.new_address = params[:order][:new_address]
      @order.new_name = params[:order][:new_name]
    else
      render 'new'
    end

  end

  def create
    @order = Order.new
    @order.customer_id = current_customer.id
    @order.shipping = 800
    @cart_items = CartItem.where(customer_id: current_customer.id)
    ary = []
    @cart_items.each do |cart_item|
      ary << cart_item.item.excluding_tax_price * 1.1 * cart_item.amount
    end
    @cart_items_price = ary.sum
    @order.total = @order.shipping + @cart_items_price
    @order.payment_method = params[:order][:payment_method]
    if @order.payment_method == "credit_card"
      @order.order_status = 1
    else
      @order.order_status = 0
    end

    order.address = params[:order][:order.address]
    case order.address
      when "customer_address"
        @order.postal_code = current_customer.postal_code
        @order.address = current_customer.address
        @order.name = current_customer.last_name + current_customer.first_name
      when "shipping_address"
        Addresse.find(params[:order][:shipping_address])
        selected = Addresse.find(params[:order][:shipping_address])
        @order.postal_code = selected.postal_code
        @order.address = selected.address
        @order.name = selected.name
      when "new_address"
        @order.postal_code = params[:order][:new_postal_code]
        @order.address = params[:order][:new_address]
        @order.name = params[:order][:new_name]
    end

      if @order.save
        if @order.order_status == 0
          @cart_items.each do |cart_item|
            OrderDetail.create!(order_id: @order.id, item_id: cart_item.item.id, price: cart_item.item.excluding_tax_price, amount: cart_item.amount, order_status: 0)
          end
        else
          @cart_items.each do |cart_item|
            OrderDetail.create!(order_id: @order.id, item_id: cart_item.item.id, price: cart_item.item.excluding_tax_price, amount: cart_item.amount, order_status: 1)
          end
        end
        @cart_items.destroy_all
        redirect_to complete_orders_path
      else
        render :items
      end
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