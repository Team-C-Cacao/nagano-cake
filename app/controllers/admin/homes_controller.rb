class Admin::HomesController < ApplicationController
  def top
    @orders = Order.page(params[:page]).per(10)
  end
#Order.page(params[:page]) ページネーション用のメソッドで、現在のページの指定
#per(10)　１ページに表示するアイテムの数の指定（最大10件の注文が表示）

end
