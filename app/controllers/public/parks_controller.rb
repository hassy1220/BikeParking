class Public::ParksController < ApplicationController
  before_action :correct_post, only: [:edit]
  before_action :move_to_signed_in, except: [:index]
  include AjaxHelper
  def new
    @park = Park.new
    @park_areas = Park.all.pluck(:lat, :lng)
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
    @start = ((params[:page] || 1).to_i - 1) * par_page + 1
    @posts = Park.includes(:favorite_user).
      sort { |a, b| b.favorite_user.size <=> a.favorite_user.size }
    # いいね順で取得した配列をkaminariに適用させる。
    @like_park = Kaminari.paginate_array(@posts).page(params[:page]).per(5)
    @vicinity = Vicinity.page(params[:vicinity_page]).per(7)

    if params[:vicinity_ids].present? || params[:engine_spec]
      # 最寄り検索した場合のメソッド
      vicinity = params[:vicinity_ids]
      engine_spec = params[:engine_spec]
      index_page = params[:index_page]
      @park_area, @parks = Park.search_for_vicinity(vicinity, engine_spec, index_page)
      if params[:vicinity_ids]
        @vicinity_place = Vicinity.find_by(id: vicinity).vicinity_name
      end
    elsif params[:address].present? || params[:engine_specs].present? || params[:address]
      # Parkモデルのsearch_forメソッドで検索(詳細検索)
      content = params[:content]
      engine_spec = params[:engine_specs]
      address = params[:address]
      index_page = params[:index_page]
      @park_area, @parks = Park.search_for(content, engine_spec, address, index_page)
      @vicinity_place
    else
      # 何も検索していない時
      @park_area = Park.pluck(:lng, :lat, :name, :id)
      @parks = Park.page(params[:index_page]).per(5)
      @vicinity_place
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
      vicinity = Vicinity.new(vicinity_params)
      @vicinity = vicinity.vicinity_name.split(",")
      @park.update_sent_vicinity(@vicinity, @park)
      flash[:notice] = "編集完了しました"
      redirect_to public_park_path(@park.id)
    else
      flash[:danger] = @park.errors.full_messages
      redirect_to edit_public_park_path
    end
  end

  def create
    vicinity = Vicinity.new(vicinity_params)
    @vicinity = vicinity.vicinity_name.split(",")
    @park = Park.new(park_params)
    @park.customer_id = current_customer.id

    if @park.save
      @park.sent_vicinity(@vicinity, @park)
      flash[:notice] = "投稿が完了しました"
      respond_to do |format|
        format.js { render ajax_redirect_to(public_park_path(@park.id)) }
      end
    else
      render :error
    end
  end

  def destroy
    park = params[:id]
    parks = current_customer.parks.ids
    if parks.include?(park.to_i)
      park_area = Park.find(park)
      park_area.destroy
      Park.destroy_sent_vicinity
    end
    redirect_to public_parks_path
  end

  private

  def park_params
    params.require(:park).permit(:lat, :lng, :name, :description, :spec,
                                 :price, :purpose, :addressOutput, :parking_time,
                                 images: [])
  end

  def vicinity_params
    params.require(:vicinity).permit(:vicinity_name)
  end

  def move_to_signed_in
    unless customer_signed_in?
      # サインインしていないユーザーはログインページが表示される
      redirect_to new_customer_session_path, notice: 'ログインしてください！'
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
