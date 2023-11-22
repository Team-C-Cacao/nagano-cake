class Public::CustomersController < ApplicationController
    #customerコントローラのアクションを実行する前にis_matching_customerを実行
    before_action :is_matching_customer

  def show
    @customer = current_customer#@customerにログインしてるcustomer情報を代入
  end

  def edit
    @customer = current_customer#@customerにログインしてるcustomer情報を代入
  end

  def update
    @customer = current_customer#@customerにログインしてるcustomer情報を代入
    if @customer.update(customer_params)#customer情報をupdateできたなら
      flash[:notice] = "登録情報を編集しました"
       redirect_to customers_path
    else
      flash.now[:alert] = "登録情報の編集に失敗しました"#customer情報をupdateできなかったなら
       render :edit
    end
  end

  def check#画面表示のみ(データ不要)
  end

  def cancellation
    @customer = current_customer#@customerにログインしてるcustomer情報を代入
    @customer.update(is_active: false)#退会ボタンを押したらis_activeの値をfalseにする
    sign_out(@customer)#退会と同時にサインアウトする
    flash[:notice] = "退会が完了しました。"
    redirect_to root_path
  end

  private
  #情報をupdateするときのカラムの許可
  def customer_params
    params.require(:customer).permit(:last_name,:first_name,:last_name_kana,:first_name_kana,:postal_code,:address,:phone_number,:email)
  end

  def is_matching_customer
    unless customer_signed_in?#customerがログインしてるかの判定
      redirect_to new_customer_registration_path#してなかったらリダイレクト
    end
  end

end
