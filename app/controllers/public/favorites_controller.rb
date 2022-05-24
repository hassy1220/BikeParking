class Public::FavoritesController < ApplicationController
  def create
    @park_area = Park.find(params[:park_id])
    if Favorite.find_by(park_id: @park_area.id,customer_id: current_customer.id)
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
    if Favorite.find_by(park_id:  @park_area.id,customer_id: current_customer.id)
      favorite = Favorite.find_by(park_id:  @park_area.id,customer_id: current_customer.id)
      favorite.destroy
    else
    end
  end
  def show
    @like_user = Park.find(params[:park_id]).favorite_user
  end


end
