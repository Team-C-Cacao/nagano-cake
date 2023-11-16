class Admin::ItemsController < ApplicationController
  def index
    @items = Item.all
    @genres = Genre.all
  end

  def new
    @item = Item.new
  end

  def show
  end

  def edit
  end
end
