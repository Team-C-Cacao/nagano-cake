class Admin::ItemsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @items = Item.with_attached_image.page(params[:page]).per(10)
    @genres = Genre.all
  end

  def new
    @item = Item.new
    @genres = Genre.all
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:notice] = "商品が登録できました"
      redirect_to admin_item_path(@item)
    else
      @genres = Genre.all
      render :new
    end
  end

  def show
    @item = Item.with_attached_image.find(params[:id])
  end

  def edit
    @item = Item.with_attached_image.find(params[:id])
    @genres = Genre.all
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to admin_item_path(@item)
    else
      @genres = Genre.all
      render :edit
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :image, :description, :genre_id, :excluding_tax_price, :is_active)
  end

end
