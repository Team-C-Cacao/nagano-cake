# frozen_string_literal: true

class Public::RegistrationsController < Devise::RegistrationsController
   #新規登録のアクションが行われる前にconfigure_sign_up_paramsメソッド実行
   before_action :configure_sign_up_params, only: [:create]

  # before_action :configure_account_update_params, only: [:update]

  #サインアップ後のリダイレクト先を指定
  def after_sign_up_path_for(resource)
   flash[:notice] = "ようこそ！ながのCAKEへ！"
      customers_path
  end

   protected

  # If you have extra params to permit, append them to the sanitizer.
  #新規登録するときのカラムを許可
   def configure_sign_up_params
     devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name,:first_name,:last_name_kana,:first_name_kana,:postal_code,:address,:phone_number,:is_active,:email])
   end

 
 end
