class SearchesController < ApplicationController

  def search
    @genres = Genre.all
    @range = params[:range] #検索対象モデル情報受取
    @word = params[:word] #検索ワード情報受取

    if @range == "Customer" #検索対象モデルがcustomerの場合
      @customers = Customer.where("last_name LIKE :name OR first_name LIKE :name OR last_name_kana LIKE :name OR first_name_kana LIKE :name",name: "%#{@word}%").page(params[:page]).per(8)
                                  #nameに"%#{@word}%"で入力した検索ワードを代入し、姓、明、セイ、メイのどれかに当てはまるものがないか調べる
                                  #この書き方は実務でも使うことがある、少し効率的な記述らしい
    else
      @items = Item.where("name LIKE?","%#{@word}%").page(params[:page]).per(8) #itemは商品名のみで探すためcustomerよりシンプル
    end
  end

end
