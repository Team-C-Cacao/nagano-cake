class Public::OrdersController < ApplicationController
  def new
  end

  def index
    @orders = Order.all
  end

  def show
    # @order = Order.find(params[:id])
  end

  def confirm
      @cart_items = CartItem.where(customer_id: current_customer.id)
      @shipping = 800 #送料は800円で固定
      @selected_payment_method = params[:order][:payment_method]

      #以下、商品合計額の計算
      ary = []
      @cart_items.each do |cart_item|
        ary << cart_item.item.price*cart_item.amount
      end
      @cart_items_price = ary.sum

      @total = @shipping + @cart_items_price
      @address_type = params[:order][:address_type]
      case @address_type
      when "customer_address"
        @selected_address = current_customer.postal_code + " " + current_customer.address + " " + current_customer.family_name + current_customer.first_name
      when "shipping_address"
        unless params[:order][:shipping_address_id] == ""
          selected = Address.find(params[:order][:shipping_address_id])
          @selected_address = selected.postal_code + " " + selected.address + " " + selected.name
      	 else
      	   render :new
      	 end
      when "new_address"
        unless params[:order][:new_postal_code] == "" && params[:order][:new_address] == "" && params[:order][:new_name] == ""
    	  @selected_address = params[:order][:new_postal_code] + " " + params[:order][:new_address] + " " + params[:order][:new_name]
    	  else
    	  render :new
    	  end
      end
  end

  def create
    @order = Order.new
      @order.customer_id = current_customer.id
      @order.shippipg = 800
      @cart_items = CartItem.where(customer_id: current_customer.id)
      ary = []
      @cart_items.each do |cart_item|
        ary << cart_item.item.price*cart_item.amount
      end
      @cart_items_price = ary.sum
      @order.total = @order.shippipg + @cart_items_price
      @order.pay_method = params[:order][:pay_method]
      if @order.pay_method == "credit_card"
        @order.order_status = 1
      else
        @order.order_status = 0
      end

      address_type = params[:order][:address_type]
      case address_type
        when "customer_address"
          @order.postal_code = current_customer.postal_code
          @order.address = current_customer.address
          @order.name = current_customer.family_name + current_customer.first_name
        when "shippipg_address"
          Addresse.find(params[:order][:shippipg_address_id])
          selected = Addresse.find(params[:order][:shippipg_address_id])
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
              OrderDetail.create!(order_id: @order.id, item_id: cart_item.item.id, price: cart_item.item.price, amount: cart_item.amount, making_order_status: 0)
            end
          else
            @cart_items.each do |cart_item|
              OrderDetail.create!(order_id: @order.id, item_id: cart_item.item.id, price: cart_item.item.price, amount: cart_item.amount, making_order_status: 1)
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

  private

  def order_params
    params.require(:order).permit(:shipping, :payment_method, :total, :order_order_status, :name, :postal_code, :address)
  end

end
