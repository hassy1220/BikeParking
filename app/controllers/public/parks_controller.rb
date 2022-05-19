class Public::ParksController < ApplicationController
  # before_action :authenticate_customer!
  before_action :correct_post,only: [:edit]
  before_action :move_to_signed_in, except:[:index]
  def new
      @park = Park.new(session[:parks] || {})
      @park_areas = Park.all.pluck(:lat,:lng)
      @park_area = Park.pluck(:lng, :lat)
      @vicinity = Vicinity.new
  end


  def show
      @park_area = Park.find(params[:id])
      @park_comment = Comment.new
      @park_comments = @park_area.comments.page(params[:page]).per(5)
      # kaminariを非同期化するための記述show.js.erbを探しにいく
      respond_to do |format|
        format.html
        format.js
      end
  end


  def index
      par_page = 5
      @start = ((params[:page] || 1 ).to_i - 1) * par_page +1
      like_park = @posts = Park.includes(:favorite_user).sort {|a,b| b.favorite_user.size <=> a.favorite_user.size}
      # いいね順で取得した配列をkaminariに適用させる。
      @like_park = Kaminari.paginate_array(like_park).page(params[:page]).per(5)
      @vicinity = Vicinity.page(params[:vicinity_page]).per(7)


      if params[:vicinity_ids].present?or params[:engine_spec]
          # 最寄り検索した場合のメソッド
          @park_area,@parks = Park.search_for_vicinity(params[:vicinity_ids],params[:engine_spec],params[:index_page])
      elsif params[:address].present?||params[:engine_specs].present?||params[:address]
          # Parkモデルのsearch_forメソッドで検索(詳細検索)
          @park_area,@parks = Park.search_for(params[:content],params[:engine_specs],params[:address],params[:index_page])
      else
          # 何も検索していない時
          @park_area = Park.pluck(:lng, :lat, :name, :id)
          @parks = Park.page(params[:index_page]).per(5)
      end

  # 　kaminariを非同期化するための記述index.js.erbを探しにいく
      respond_to do |format|
        format.html
        format.js
      end

  end


  def edit
    @park = Park.find(params[:id])
    @vicinity = @park.vicinity_parks
  end


  def update
     @park = Park.find(params[:id])
     if @park.update(park_params)
          vicinity= Vicinity.new(vicinity_params)
          @vicinity = vicinity.vicinity_name.split(",")
          @park.update_sent_vicinity(@vicinity,@park)
          redirect_to public_park_path(@park.id)
     else
          flash[:danger]=@park.errors.full_messages
          redirect_to edit_public_park_path
     end
  end


  def create
      vicinity= Vicinity.new(vicinity_params)
      @vicinity = vicinity.vicinity_name.split(",")
      @park = Park.new(park_params)
      @park.customer_id = current_customer.id
      if @park.save
         session[:parks] = nil
         @park.sent_vicinity(@vicinity,@park)
         flash[:notice]="投稿を保存しました"
         redirect_to public_parks_path
      else
         session[:parks] = @park.attributes.slice(*park_params.keys)
         flash[:danger]=@park.errors.full_messages
         redirect_to new_public_park_path
      end
  end


  def destroy
       @park_area = Park.find(params[:id])
       @park_area.destroy
       Park.destroy_sent_vicinity
       redirect_to public_parks_path
  end




  private
  def park_params
      params.require(:park).permit(:lat,:lng,:name,:description,:spec,:price,:purpose,:addressOutput,:parking_time,images: [])
  end

  def vicinity_params
      params.require(:vicinity).permit(:vicinity_name)
  end

  def move_to_signed_in
      unless customer_signed_in?
          #サインインしていないユーザーはログインページが表示される
          redirect_to new_customer_session_path
      end
  end

  # URL直打ち他人の編集ページに活かせない
  def correct_post
      @park = Park.find(params[:id])
      unless @park.customer.id == current_customer.id
        redirect_to public_parks_path
      end
  end
end
