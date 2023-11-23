class Public::ShippingAddressesController < ApplicationController
  def index #一覧表示ページに配送先情報を表示するだけでなく、新しい配送先を入力するフォームを表示するようにしている。
    @shipping_addresses = ShippingAddress.where(customer: current_customer) #customerカラムがcurrent_customerと一致するものを選択する
    @shipping_address = ShippingAddress.new
  end

  def create  #新しい配送先情報を作成し、データベースに保存する
      @shipping_address = ShippingAddress.new(shipping_address_params)
      @shipping_address.customer_id = current_customer.id #ShippingAdressオブジェクトに現在のユーザー('cuurent_customer')のIDを関連付けする。それにより新しい配送先情報がどのユーザーに関連しているか示す。
      if @shipping_address.save
        redirect_to request.referer, notice: "新規配送先を登録しました。" #リダイレクトして元々のページに戻り成功メッセージを表示
      else #失敗したら
        @shipping_addresses = ShippingAddress.where(customer: current_customer) 
        render 'index' #ビューを表示し、エラーを伝える
      end
  end

  def destroy #特定の配送先情報を削除して、一覧ページにリダイレクトする
    @shipping_address = ShippingAddress.find(params[:id])
    @shipping_address.destroy  #配送先情報を削除
    flash.now[:alert] = "配送先を削除しました" #フラッシュメッセージ
    redirect_to shipping_addresses_path #配送先一覧ページにリダイレクト
  end

  def edit #対象となる配送先情報がデータベースから取得、それを編集するためのフォームを表示
    @shipping_address = ShippingAddress.find(params[:id])
  end


  def update  #特定の配送先情報を更新、表示する
    @shipping_address = ShippingAddress.find(params[:id]) 
    if @shipping_address.update(shipping_address_params) #更新が成功した場合、配送先一覧ページにリダイレクトし、成功メッセージを表示
      redirect_to shipping_addresses_path, notice: "配達先を変更しました。" #
    else
      render :edit # 更新が失敗した場合、編集画面を表示
    end
  end

  private

  def shipping_address_params #パラメーターの取得と許可
    params.require(:shipping_address).permit(:postal_code, :shipping_address, :name)
  end

end