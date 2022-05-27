class Public::CustomersController < ApplicationController
  before_action :correct_customer, only: [:edit, :update, :unsubscribe, :withdrawal]
  before_action :ensure_guest_customer, only: [:edit]
  def index
    @customers = Customer.where(is_deleted: false)
  end

  def show
    @customer = Customer.find(params[:id])
    @customer_park = @customer.parks.page(params[:page]).per(6)
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    customer = Customer.find(params[:id])
    if customer.update(customer_params)
      redirect_to public_customer_path(customer.id)
    else
      flash[:danger] = customer.errors.full_messages
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
    params.require(:customer).permit(:name, :description, :bike_image, my_bike_images: [])
  end

  # URL直打ちしたら、マイページに飛ばす(編集、更新、退会)
  def correct_customer
    @customer = Customer.find(params[:id])
    unless @customer == current_customer
      redirect_to public_customer_path(current_customer.id), notice: '他人のプロフィール編集画面へ遷移できません。'
    end
  end

  def ensure_guest_customer
    @customer = Customer.find(params[:id])
    if @customer.name == "guestuser"
      redirect_to public_customer_path(current_customer), notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end
end
