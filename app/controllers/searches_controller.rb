class SearchesController < ApplicationController

  def search
    @range = params[:range]
    @word = params[:word]

    # 管理者がサインインしている場合はitemとcustomer両方を検索可能
    if admin_signed_in?
    @range == "Item"
      @items = Item.looks(params[:search], params[:word])
    @range == "Customer"
      @customers = Customer.looks(params[:search], params[:word])
    # 顧客がサインインしている場合はitemのみを検索
    elsif customer_signed_in?
      @items = Item.looks(params[:search], @word) if @range == "Item"
    end
  end

  def genre_search
    @genres
    @genre_id = params[:genre_id]
    @items = Item.where(genre_id: @genre_id)
  end

end
