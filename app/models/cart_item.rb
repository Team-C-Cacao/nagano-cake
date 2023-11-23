class CartItem < ApplicationRecord
  
  # 関連付け
  belongs_to :customer
  belongs_to :item
  
  # バリデーション
  validates :amount, presence: true
  
  # 税込価格を計算するメソッド
  # 商品の税抜価格に10%を加えて返す  
  def tax_included_price
    item.excluding_tax_price * 1.10
  end
  
  # 小計を計算するメソッド
  # 税込価格に数量を掛けたものを返す
  def subtotal
    tax_included_price * amount
  end
  
  # カート内の総額を計算するメソッド
  # 各CartItemの小計の合計を返す
  def total_price
    cart_items.sum(&:subtotal)
  end
  
  # 顧客と商品IDに基づいてCartItemを検索するクラスメソッド
  # 一致するCartItemがあればそれを返し、なければnilを返す
  def self.find_for_customer_and_item(customer_id, item_id)
    find_by(customer_id: customer_id, item_id: item_id)
  end

  # CartItemを更新するか新しく作成するクラスメソッド
  # 顧客IDと商品IDに基づいてCartItemを検索し、存在する場合は数量を更新、
  # 存在しない場合は新しいCartItemを作成する
  def self.update_or_create(customer_id, item_id, amount)
    cart_item = find_for_customer_and_item(customer_id, item_id)
    if cart_item
      cart_item.update(amount: cart_item.amount.to_i + amount.to_i)
    else
      create(customer_id: customer_id, item_id: item_id, amount: amount)
    end
  end

end
