class Public::HomesController < ApplicationController
  def top
    # ジャンル取得
    @genres = Genre.all
    # 販売中の全商品から5個ランダムで取得
    @items = Item.where(is_active: true).order("RANDOM()").limit(5)
    # 新着商品を6個取得
    @newitems = Item.where(is_active: true).order(created_at: :desc).limit(6)
  end

  def about
    @items1 = Item.where(is_active: true).order(created_at: :desc).limit(10)
    @items2 = Item.where(is_active: true).order(created_at: :asc).limit(10)

  end
end
