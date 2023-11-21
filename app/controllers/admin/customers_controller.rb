class Admin::CustomersController < ApplicationController
  def index
    @customers = Customer.all.page(params[:page]).per(10)
    @range = "Customer"
  end

  def show
    @customer = Customer.find(params[:id])
    @range = "Customer"
  end

  def edit
    @customer = Customer.find(params[:id])
    @user = @customer
    @range = "Customer"
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      flash[:notice] = "登録情報を編集しました"
    redirect_to admin_customer_path(@customer)
    else
    @user = Customer.find(params[:id])
    flash.now[:alert] = "登録情報の編集に失敗しました"
    render :edit
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:last_name,:first_name,:last_name_kana,:first_name_kana,:postal_code,:address,:phone_number,:email,:is_active)
  end

end
