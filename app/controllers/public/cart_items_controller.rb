class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!

  def index
    @cart_items = CartItem.where(customer_id: current_customer.id)
    @total_price = @cart_items.sum(&:subtotal)
  end

  def create
    if cart_item_params[:amount].present?
      CartItem.update_or_create(current_customer.id, cart_item_params[:item_id], cart_item_params[:amount])
      redirect_to_success
    else
      redirect_to_failure
    end
  end

  def update
    @cart_item = CartItem.find(params[:id])
    if @cart_item.update(cart_item_params)
      redirect_to cart_items_path, notice: "#{@cart_item.item.name}の数量を#{@cart_item.amount}個に更新しました。"
    else
      render 'cart_items/index', alert: "数量の更新に失敗しました。"
    end
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    item_name = @cart_item.item.name
    if @cart_item.destroy
      redirect_to cart_items_path, alert: "#{item_name}を削除しました。"
    else
      render 'cart_items/index', alert: "#{item_name}の削除に失敗しました。"
    end
  end

  def destroy_all
    CartItem.where(customer_id: current_customer.id).destroy_all
    redirect_to cart_items_path, alert: "カート内商品をすべて削除しました。"
  end


  private

  def redirect_to_success
    item = Item.find(cart_item_params[:item_id])
    redirect_to cart_items_path, notice: "#{item.name}を#{cart_item_params[:amount]}個カートに追加しました。"
  end

  def redirect_to_failure
    redirect_to item_path(cart_item_params[:item_id]), alert: "数量を選択してください。"
  end

  def cart_item_params
    params.dig(:cart_item) ? params.require(:cart_item).permit(:item_id, :amount) : params.permit(:item_id, :amount)
  end
end
