class Public::ItemsController < ApplicationController
  def index
    @items = Item.all
    @genres = Genre.all
  end

  def show
    @item = Item.find(params[:id])
  end
  
  private
  
  def item_params
    params.require(:item).permit(:name, :image, :description, :genre_id, :excluding_tax_price, :is_active)
  end
  
end
