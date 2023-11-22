# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
   before_action :configure_sign_in_params, only: [:create]
   before_action :customer_state,only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end
  def after_sign_in_path_for(resource)
   flash[:notice] = "ようこそ！ながのCAKEへ！"
      root_path
  end
  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end
  private
  def customer_state
   customer = Customer.find_by(email: params[:customer][:email])
   return if customer.nil?
   return unless customer.valid_password?(params[:customer][:password])# 【処理内容3】 取得したアカウントのパスワードと入力されたパスワードが一致していない場合、このメソッドを終了する
   unless customer.is_active == true
     flash[:alert] = "すでに退会しています。"
      redirect_to new_customer_registration_path
   end
  end

   protected

  # If you have extra params to permit, append them to the sanitizer.
   def configure_sign_in_params
     devise_parameter_sanitizer.permit(:sign_in, keys: [:email])
   end
end
