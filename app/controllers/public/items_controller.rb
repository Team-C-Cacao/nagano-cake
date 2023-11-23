class Public::ItemsController < ApplicationController
  def index
    if params[:genre_id].nil? #genre_idが無かったら(全商品一覧ページの場合)
      @items = Item.with_attached_image.order("RANDOM()").page(params[:page]).per(8) #item全件取得し、1ページあたり8個ずつ表示
    else
      @genre = Genre.find(params[:genre_id].to_i)# genre_idがあれば(ジャンル別商品一覧ページの場合)
      @items = Item.with_attached_image.where(genre_id: params[:genre_id].to_i).page(params[:page]).per(8) #genre_idが一致するitem全件取得し、1ページあたり8個ずつ表示
    end
    @genres = Genre.all #genre検索フォーム表示
  end

  def show
    @item = Item.with_attached_image.find(params[:id]) #詳細表示したいitemのデータ取得
    @genres = Genre.all #genre検索フォーム表示
  end

  private

  def item_params
    params.require(:item).permit(:name, :image, :description, :genre_id, :excluding_tax_price, :is_active)
  end

end
