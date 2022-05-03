class Public::FavoritesController < ApplicationController
  def create
    park = Park.find(params[:park_id])
    if Favorite.find_by(park_id: park.id,customer_id: current_customer.id)
      redirect_to request.referer
    else
      favorite = Favorite.new
      favorite.park_id = park.id
      favorite.customer_id = current_customer.id
      favorite.save
      redirect_to request.referer
    end
  end
  def destroy
    park = Park.find(params[:park_id])
    if Favorite.find_by(park_id: park.id,customer_id: current_customer.id)
      favorite = Favorite.find_by(park_id: park.id,customer_id: current_customer.id)
      favorite.destroy
      redirect_to request.referer
    else
      redirect_to request.referer
    end
  end
end
