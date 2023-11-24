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

  def destroy
   # Devise.sign_out_all_scopesとはdeviseでサインアウトするときに複数のスコープ(管理者、顧客)が存在する場合、すべてのスコープからサインアウトするかどうかを制御する設定
   # Devise.sign_out_all_scopesがtrueなら全てのスコープからサインアウトする、falseなら特定のスコープからのみサインアウトが行われる
   # この設定は、config/initializers/devise.rb などでカスタマイズできる
   # Devise.sign_out_all_scopes の値に基づいて sign_out を実行するかどうかを条件付きで設定する
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    # signed_outがtrueの時:alertメッセージ :signed_out をflashに設定する
    # set_flash_message! メソッドはDeviseのヘルパーメソッドで、flashメッセージを設定するために使用される
    set_flash_message! :alert, :signed_out if signed_out
    # サインアウトが完了した後の処理
    respond_to_on_destroy
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
