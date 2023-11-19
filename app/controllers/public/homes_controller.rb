class Public::HomesController < ApplicationController
  def top
    @genres = Genre.all

    @items = Item.where(is_active: true).order("RANDOM()").limit(5)

  end

  def about
  end
end
