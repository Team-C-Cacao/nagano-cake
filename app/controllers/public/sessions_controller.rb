# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
   #サインインする前にconfigure_sign_in_paramsメソッド実行
   before_action :configure_sign_in_params, only: [:create]
   #サインインする前にcustomer_state実行
   before_action :customer_state,only: [:create]

  #サインイン後のリダイレクト先を指定してflashメッセージを表示
  def after_sign_in_path_for(resource)
   flash[:notice] = "ようこそ！ながのCAKEへ！"
      root_path
  end

  private

  def customer_state
   customer = Customer.find_by(email: params[:customer][:email])#customerモデルに保存されてるデータの中から入力フォームから送られたemailに紐づくcustomerの情報を取得する
   return if customer.nil?#取得してきたcustomerのデータが存在するか判定、ないならメソッド終了
   return unless customer.valid_password?(params[:customer][:password])#取得したアカウントのパスワードと入力されたパスワードが一致していない場合、このメソッドを終了する
   unless customer.is_active == true#会員ステータスがtrueでないなら新規登録画面に戻る
     flash[:alert] = "すでに退会しています。"
      redirect_to new_customer_registration_path
   end
  end

   protected
  #サインインするときのカラムの許可
   def configure_sign_in_params
     devise_parameter_sanitizer.permit(:sign_in, keys: [:email])
   end
end
