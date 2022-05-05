class Public::ParksController < ApplicationController
  before_action :move_to_signed_in, except: [:index]
  def new
    @park = Park.new
    @park_areas = Park.all.pluck(:lat,:lng)
    @park_area = Park.pluck(:lng, :lat)
  end

  def show
    @park_area = Park.find(params[:id])
    @park_comment = Comment.new
  end

  def index
    @like_park = @posts = Park.includes(:favorite_user).sort {|a,b| b.favorite_user.size <=> a.favorite_user.size}
    if params[:content].blank?
      @park_area = Park.pluck(:lng, :lat, :name, :id)
      @parks = Park.page(params[:page]).per(5)
    else
      # 目的地か駐車場名から検索した場合の処理
      @park_area = Park.where('purpose LIKE ?',"%#{params[:content]}%").or(Park.where('name LIKE ?',"%#{params[:content]}%")).pluck(:lng, :lat, :name, :id)
      @parks = Park.where('purpose LIKE ?',"%#{params[:content]}%").page(params[:page]).per(5)
    end

  end

  def create
    @park = Park.new(park_params)
    @park.customer_id = current_customer.id
    if @park.save
      redirect_to public_parks_path
    else
      flash[:danger]=@park.errors.full_messages
      redirect_to new_public_park_path
    end
  end

  def destroy
     @park_area = Park.find(params[:id])
     @park_area.destroy
     redirect_to public_parks_path
  end


  private
  def park_params
    params.require(:park).permit(:lat,:lng,:name,:description,:spec,:price,:purpose,:parking_time,images: [])
  end

  def move_to_signed_in
    unless customer_signed_in?
      #サインインしていないユーザーはログインページが表示される
      redirect_to new_customer_session_path
    end
  end
end
