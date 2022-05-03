class Public::CustomersController < ApplicationController
  def index
    @customers = Customer.where(is_deleted: false)
  end
  def show
    @customer = Customer.find(params[:id])
  end
  def edit
    @customer = Customer.find(params[:id])
  end
  def update
    customer = Customer.find(params[:id])
    if customer.update(customer_params)
      redirect_to public_customer_path(customer.id)
    else
      flash[:danger]=customer.errors.full_messages
      redirect_to request.referer
    end
  end
  def withdrawal
    @customer = Customer.find(params[:id])
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    @customer.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end



  private
  def customer_params
    params.require(:customer).permit(:name,:description,:bike_image)
  end

end
