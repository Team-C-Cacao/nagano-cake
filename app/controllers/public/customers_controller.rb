class Public::CustomersController < ApplicationController
  def show
    @customer = current_customer
  end

  def edit
    @customer = current_customer
  end

  def update
    @customer = current_customer
    @customer.update(customer_params)
    redirect_to customers_path
  end

  def check
  end

  def cancellation
    @customer = current_customer
    @customer.update(is_active: false)
    sign_out(@customer)
    redirect_to root_path,notice: "退会が完了しました。"
  end

  private
  def customer_params
    params.require(:customer).permit(:last_name,:first_name,:last_name_kana,:first_name_kana,:postal_code,:address,:phone_number,:email)
  end

end
