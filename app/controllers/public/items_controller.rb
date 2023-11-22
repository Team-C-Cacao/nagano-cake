class Public::ItemsController < ApplicationController
  def index
    if params[:genre_id].nil?
      @items = Item.all.page(params[:page]).per(8)
    else
      @genre = Genre.find(params[:genre_id].to_i)
      @items = Item.where(genre_id: params[:genre_id].to_i).page(params[:page]).per(8)
    end
    @genres = Genre.all
  end

  def show
    @item = Item.find(params[:id])
    @genres = Genre.all
  end

  private

  def item_params
    params.require(:item).permit(:name, :image, :description, :genre_id, :excluding_tax_price, :is_active)
  end

end
