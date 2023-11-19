class Public::CustomersController < ApplicationController
<<<<<<< HEAD
  before_action :authenticate_customer!
=======

    before_action :is_matching_customer
>>>>>>> origin/develop

  def show
    @customer = current_customer
  end

  def edit
    @customer = current_customer
  end

  def update
    @customer = current_customer
    if @customer.update(customer_params)
       redirect_to customers_path
    else
       render :edit
    end
  end

  def check
  end

  def cancellation
    @customer = current_customer
    @customer.update(is_active: false)
    sign_out(@customer)
    flash[:notice] = "退会が完了しました。"
    redirect_to root_path
  end

  private
  def customer_params
    params.require(:customer).permit(:last_name,:first_name,:last_name_kana,:first_name_kana,:postal_code,:address,:phone_number,:email)
  end

  def is_matching_customer
    unless customer_signed_in?
      redirect_to new_customer_registration_path
    end
  end


end
