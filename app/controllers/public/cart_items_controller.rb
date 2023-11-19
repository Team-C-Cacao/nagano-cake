class Public::CartItemsController < ApplicationController
  def index
    @cart_items = CartItem.where(customer_id: current_customer.id)
    @total_price = @cart_items.sum(&:subtotal)
  end

  def create
    if valid_amount?
      update_or_create_cart_item
      redirect_to_success
    else
      redirect_to_failure
    end
  end

  def update
    @cart_item = CartItem.find(params[:id])
    if @cart_item.update(cart_item_params)
      redirect_to cart_items_path, notice: '数量を#{@cart_item.amount}に更新しました。'
    else
      render 'cart_items/index', notice: '数量の更新に失敗しました。'
    end
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    item_name = @cart_item.item.name
    if @cart_item.destroy
      redirect_to cart_items_path, notice: '#{item_name}を削除しました。'
    else
      render 'cart_items/index', notice: '#{item_name}の削除に失敗しました。'
    end
  end

  def destroy_all
    CartItem.where(customer_id: current_customer.id).destroy_all
    redirect_to cart_items_path
  end


  private

  def valid_amount?
    cart_item_params[:amount].present?
  end

  def update_or_create_cart_item
    current_cart_item = find_current_cart_item
    if current_cart_item
      update_cart_item(current_cart_item)
    else
      create_cart_item
    end
  end

  def find_current_cart_item
    CartItem.find_by(customer_id: current_customer.id, item_id: cart_item_params[:item_id])
  end

  def update_cart_item(cart_item)
    cart_item.update(amount: cart_item.amount.to_i + cart_item_params[:amount].to_i)
  end

  def create_cart_item
    cart_item = CartItem.new(cart_item_params)
    cart_item.customer_id = current_customer.id
    cart_item.save
  end

  def redirect_to_success
    item = Item.find(cart_item_params[:item_id])
    redirect_to cart_items_path, notice: "#{item.name}を#{cart_item_params[:amount]}個カートに追加しました。"
  end

  def redirect_to_failure
    redirect_to item_path(cart_item_params[:item_id]), notice: "数量を選択してください。"
  end

  def cart_item_params
    params.dig(:cart_item) ? params.require(:cart_item).permit(:item_id, :amount) : params.permit(:item_id, :amount)
  end
end
