class SearchesController < ApplicationController
  def search
    @range = params[:range]
    @word = params[:word]

    if admin_signed_in? && @range == "Customer"
      @customers = Customer.where("last_name LIKE :name OR first_name LIKE :name OR last_name_kana LIKE :name OR first_name_kana LIKE :name", name: "%#{@word}%").page(params[:page]).per(10)
    else
      @items = Item.where("name LIKE ?", "%#{@word}%").page(params[:page]).per(10)
    end
  end
end
