class Public::ParksController < ApplicationController
  before_action :move_to_signed_in, except: [:index]
  def new
    @park = Park.new
    @park_areas = Park.all.pluck(:lat,:lng)
    @park_area = Park.pluck(:lng, :lat)
    @place = params[:place_address]
  end

  def show
    @park_area = Park.find(params[:id])
    @park_comment = Comment.new
    @park_comments = @park_area.comments.page(params[:page]).per(5)
  end

  def index
    par_page = 5
    @start = ((params[:page] || 1 ).to_i - 1) * par_page +1
    like_park = @posts = Park.includes(:favorite_user).sort {|a,b| b.favorite_user.size <=> a.favorite_user.size}
    # いいね順で取得した配列をkaminariに適用させる。
    @like_park = Kaminari.paginate_array(like_park).page(params[:page]).per(5)


    # 目的地・駐車場名検索しているかどうか判定
    if params[:content].blank?
        # 目的地・駐車場名検索していないが、駐車可能条件検索しているか判定
        if params[:engine_spec].blank?
          # 住所を選択しているか
          if params[:address].blank?
            @park_area = Park.pluck(:lng, :lat, :name, :id)
            @parks = Park.page(params[:index_page]).per(5)
          else
            @park_area = Park.where('addressOutput LIKE ?',"%#{params[:address]}%").pluck(:lng, :lat, :name, :id)
            @parks = Park.where('addressOutput LIKE ?',"%#{params[:address]}%").page(params[:index_page]).per(5)
          end
        else
          if params[:address].blank?
            @park_area = Park.where(spec: params[:engine_spec]).pluck(:lng, :lat, :name, :id)
            @parks = Park.where(spec: params[:engine_spec]).page(params[:index_page]).per(5)
          else
            @park_area = Park.where(spec: params[:engine_spec]).where('addressOutput LIKE ?',"%#{params[:address]}%").pluck(:lng, :lat, :name, :id)
            @parks = Park.where(spec: params[:engine_spec]).where('addressOutput LIKE ?',"%#{params[:address]}%").page(params[:index_page]).per(5)
          end
        end
    else
        if params[:engine_spec].blank?
          if params[:address].blank?
            # 目的地か駐車場名から検索した場合の処理
            @park_area = Park.where('purpose LIKE ?',"%#{params[:content]}%").or(Park.where('name LIKE ?',"%#{params[:content]}%")).pluck(:lng, :lat, :name, :id)
            @parks = Park.where('purpose LIKE ?',"%#{params[:content]}%").page(params[:index_page]).per(5)
          else
            @park_area = Park.where('purpose LIKE ?',"%#{params[:content]}%").or(Park.where('name LIKE ?',"%#{params[:content]}%")).where('addressOutput LIKE ?',"%#{params[:address]}%").pluck(:lng, :lat, :name, :id)
            @parks = Park.where('purpose LIKE ?',"%#{params[:content]}%").where('addressOutput LIKE ?',"%#{params[:address]}%").page(params[:index_page]).per(5)
          end
        else
          @park_area = Park.where('purpose LIKE ?',"%#{params[:content]}%").or(Park.where('name LIKE ?',"%#{params[:content]}%")).where(spec: params[:engine_spec]).where('addressOutput LIKE ?',"%#{params[:address]}%").pluck(:lng, :lat, :name, :id)
          @parks = Park.where('purpose LIKE ?',"%#{params[:content]}%").where(spec: params[:engine_spec]).where('addressOutput LIKE ?',"%#{params[:address]}%").page(params[:index_page]).per(5)
        end
    end
# 　kaminariを非同期化するための記述index.js.erbを探しにいく
    respond_to do |format|
      format.html
      format.js
    end


  end

  def edit
    @park = Park.find(params[:id])
  end

  def update
   @park = Park.find(params[:id])

   @park.update(park_params)
   redirect_to public_park_path(@park.id)
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
    params.require(:park).permit(:lat,:lng,:name,:description,:spec,:price,:purpose,:addressOutput,:parking_time,images: [])
  end

  def move_to_signed_in
    unless customer_signed_in?
      #サインインしていないユーザーはログインページが表示される
      redirect_to new_customer_session_path
    end
  end
end
