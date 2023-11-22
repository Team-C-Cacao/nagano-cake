class Admin::CustomersController < ApplicationController
  def index
    @customers = Customer.page(params[:page]).per(10)#customerデータを全取得し、1ページ毎にに10件のデータを表示する
    @range = "Customer"
  end

  def show
    @customer = Customer.find(params[:id])#customerモデルから1件のデータを取得
    @range = "Customer"
  end

  def edit
    @customer = Customer.find(params[:id])#customerモデルから1件のデータを取得
    @user = @customer#編集中に名前でエラーが起こった時にエラーなのに記述内容が更新される不具合を解消するための記述
    @range = "Customer"
  end

  def update
    @customer = Customer.find(params[:id])#customerモデルから1件のデータを取得
    if @customer.update(customer_params)
      flash[:notice] = "登録情報を編集しました"
    redirect_to admin_customer_path(@customer)
    else
    @user = Customer.find(params[:id])#編集中に名前でエラーが起こった時にエラーなのに記述内容が更新される不具合を解消するための記述
    flash.now[:alert] = "登録情報の編集に失敗しました"
    render :edit
    end
  end

  private

  #updateするときのカラムの許可
  def customer_params
    params.require(:customer).permit(:last_name,:first_name,:last_name_kana,:first_name_kana,:postal_code,:address,:phone_number,:email,:is_active)
  end

end
