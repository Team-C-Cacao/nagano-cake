class Admin::GenresController < ApplicationController
  def index
    @genre = Genre.new #genre新規登録用の箱
    @genres = Genre.all #genre全件取得
  end

  def create
    @genre = Genre.new(genre_params) #genre新規登録データ取得
    if @genre.save #保存
      redirect_to request.referer, notice: "ジャンルを登録しました。" #genre一覧に戻る
    else
      @genres = Genre.all
      flash.now[:alert] = "ジャンル名が入力されていません。"
      render 'index'
    end
  end

  def edit
    @genre = Genre.find(params[:id]) #編集したいgenreのデータ取得
  end

  def update
    @genre = Genre.find(params[:id]) #更新したいgenreのデータ取得
    if @genre.update(genre_params) #対象データ更新
      redirect_to admin_genres_path #genre一覧に戻る
    else
      flash.now[:alert] = "ジャンル名が入力されていません。"
      render 'edit'
    end
  end

  def destroy #便宜上追加
    @genre = Genre.find(params[:id])
    genre_name = @genre.name
    if @genre.destroy
      redirect_to admin_genres_path, alert: "#{genre_name}を削除しました。"
    else
      @genres = Genre.all
      render 'index', alert: "#{genre_name}の削除に失敗しました。"
    end
  end


  private

  def genre_params
     params.require(:genre).permit(:name)
  end

end
