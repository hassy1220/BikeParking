class Public::FavoritesController < ApplicationController
  before_action :move_to_signed_in
  def create
    @park_area = Park.find(params[:park_id])
    if Favorite.find_by(park_id: @park_area.id, customer_id: current_customer.id)
    else
      favorite = Favorite.new
      favorite.park_id = @park_area.id
      favorite.customer_id = current_customer.id
      favorite.save
      @park_area.create_notification_like!(current_customer)
    end
  end

  def destroy
    @park_area = Park.find(params[:park_id])
    if Favorite.find_by(park_id: @park_area.id, customer_id: current_customer.id)
      favorite = Favorite.find_by(park_id: @park_area.id, customer_id: current_customer.id)
      favorite.destroy
    else
    end
  end

  def show
    @like_user = Park.find(params[:park_id]).favorite_user
  end

private
  def move_to_signed_in
    unless customer_signed_in?
      # サインインしていないユーザーはログインページが表示される
      redirect_to new_customer_session_path, notice: 'ログインしてください！'
    end
  end
end
