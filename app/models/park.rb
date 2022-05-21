class Park < ApplicationRecord
  has_many_attached :images
  has_many:comments,dependent: :destroy
  belongs_to:customer
  has_many:favorites,dependent: :destroy
  has_many:favorite_user,through: :favorites,source: :customer
  has_many:notifications,dependent: :destroy
  has_many:vicinity_parks,dependent: :destroy
  has_many:park_vicinity,through: :vicinity_parks,source: :vicinity

  enum spec: { small: 0, mideam: 1, big: 2, medeamorbig: 3 }
  enum address: {zenniki: 0 ,Hakata: 1, Chuo: 2}

  validates :name,presence: true
  validates :purpose,presence: true
  validates :lat,length: { minimum: 4}
  FILE_NUMBER_LIMIT = 3
  validate :validate_number_of_files
  PRICE_NUMBER_LIMIT = 0
  validate :validate_number_of_price

  def get_image(width,height)
    unless images.attached?
      file_path = Rails.root.join("app/assets/images/parking-space-g37442e9c0_1280.jpg")
      images.attach(io:File.open(file_path),filename:"default-image.jpg",content_type:"image/jpeg")
    end
  end

   #そのユーザーが良いねしているか判定
  def user_favorite_by(user)
    favorite_user.exists?(id: user.id)
  end

  def create_notification_like!(current_customer)
  # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and park_id = ? and action = ? ", current_customer.id, customer_id, id, 'like'])
    if temp.blank?
      notification = current_customer.active_notifications.new(
        park_id: id,
        visited_id: customer_id,
        action: 'like'
      )
      # 自分の投稿を良いねしていなかったらセーブする
      unless notification.visitor_id == notification.visited_id
        notification.save if notification.valid?
      end
    end
  end


  def create_notification_comment!(current_customer, comment_id)
      # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
      temp_ids = Comment.select(:customer_id).where(park_id: id).where.not(customer_id: current_customer.id).distinct
      temp_ids.each do |temp_id|
         save_notification_comment!(current_customer, comment_id, temp_id['customer_id'])
      end
      # まだ誰もコメントしていない場合は、投稿者に通知を送る
      save_notification_comment!(current_customer, comment_id, customer_id) if temp_ids.blank?
  end


  def save_notification_comment!(current_customer, comment_id, visited_id)
      # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
      notification = current_customer.active_notifications.new(
        park_id: id,
        comment_id: comment_id,
        visited_id: visited_id,
        action: 'comment'
      )
      # 自分の投稿に対するコメントの場合は、通知済みとする
      unless notification.visitor_id == notification.visited_id
        notification.save if notification.valid?
      end
  end

  def sent_vicinity(vicinity,park)
        # 現在保存してるデータ
        current_vicinity = Vicinity.pluck(:vicinity_name)
        # 今回初めて受け付けた名前
        new_vicinities = vicinity - current_vicinity
        # 今回初めて受け付けた名前をDBに保存
        new_vicinities.each do |new|
          Vicinity.create(vicinity_name: new)
        end
        # パラメータで受け取った値を中間テーブルにPark.idとvicinity_idで保存
        vicinity.each do |new|
          VicinityPark.create(vicinity_id: Vicinity.find_by(vicinity_name: new).id, park_id: park.id)
        end
        # Vicinity.pluck(:vicinity_name) -
  end


  # 投稿内容編集するときのアップデート
  def update_sent_vicinity(vicinity,park)
        VicinityPark.where(park_id: park.id).destroy_all
        # 現在保存してるデータ
        current_vicinity = Vicinity.pluck(:vicinity_name)
        # 今回初めて受け付けた名前
        new_vicinities = vicinity - current_vicinity
        # 今回初めて受け付けた名前をDBに保存
        new_vicinities.each do |new|
          Vicinity.create(vicinity_name: new)
        end
        vicinity.each do |new|
          VicinityPark.create(vicinity_id: Vicinity.find_by(vicinity_name: new).id, park_id: park.id)
        end
        delete_vicinity = Vicinity.pluck(:id)-VicinityPark.pluck(:vicinity_id)
        Vicinity.where(id: delete_vicinity).destroy_all
  end

  # 投稿削除した時に紐づいてる最寄りの施設が宙にuteいる場合、削除する
  def self.destroy_sent_vicinity
       delete_vicinity = Vicinity.pluck(:id)-VicinityPark.pluck(:vicinity_id)
       Vicinity.where(id: delete_vicinity).destroy_all
  end

# 　目的地、住所、駐車可能条件検索
  def self.search_for(content,engine_spec,address,index_page)
    if content.blank?
          # 目的地・駐車場名検索していないが、駐車可能条件検索しているか判定
          if engine_spec.blank?
              # 住所を選択しているか
              if address.blank?
                  @park_area = Park.pluck(:lng, :lat, :name, :id),
                  @parks = Park.page(index_page).per(5)
              else
                  @park_area = Park.where('addressOutput LIKE ?',"%#{address}%").pluck(:lng, :lat, :name, :id),
                  @parks = Park.where('addressOutput LIKE ?',"%#{address}%").page(index_page).per(5)

              end
          else
              if address.blank?
                  @park_area = Park.where(spec: engine_spec).pluck(:lng, :lat, :name, :id),
                  @parks = Park.where(spec: engine_spec).page(index_page).per(5)
              else
                  @park_area = Park.where(spec: engine_spec).where('addressOutput LIKE ?',"%#{address}%").pluck(:lng, :lat, :name, :id),
                  @parks = Park.where(spec: engine_spec).where('addressOutput LIKE ?',"%#{address}%").page(index_page).per(5)
              end
          end
    else
        if engine_spec.blank?
              if address.blank?
                # 目的地か駐車場名から検索した場合の処理
                  @park_area = Park.where('purpose LIKE ?',"%#{content}%").or(Park.where('name LIKE ?',"%#{content}%")).pluck(:lng, :lat, :name, :id),
                  @parks = Park.where('purpose LIKE ?',"%#{content}%").page(index_page).per(5)
              else
                  @park_area = Park.where('purpose LIKE ?',"%#{content}%").or(Park.where('name LIKE ?',"%#{content}%")).where('addressOutput LIKE ?',"%#{address}%").pluck(:lng, :lat, :name, :id),
                  @parks = Park.where('purpose LIKE ?',"%#{content}%").where('addressOutput LIKE ?',"%#{address}%").page(index_page).per(5)
              end
        else
                  @park_area = Park.where('purpose LIKE ?',"%#{content}%").or(Park.where('name LIKE ?',"%#{content}%")).where(spec: engine_spec).where('addressOutput LIKE ?',"%#{address}%").pluck(:lng, :lat, :name, :id),
                  @parks = Park.where('purpose LIKE ?',"%#{content}%").where(spec: engine_spec).where('addressOutput LIKE ?',"%#{address}%").page(index_page).per(5)
        end
    end
  end

  #最寄り検索した場合のメソッド
  def self.search_for_vicinity(vicinity_ids,engine_spec,index_page)
    if vicinity_ids.blank?
      if engine_spec.blank?
         @park_area = Park.pluck(:lng, :lat, :name, :id),
         @parks = Park.page(index_page).per(5)
      else
         @park_area = Park.where(spec: engine_spec).pluck(:lng, :lat, :name, :id),
         @parks = Park.where(spec: engine_spec).page(index_page).per(5)
      end
    else
      if engine_spec.blank?
         @park_area = Vicinity.find_by(id: vicinity_ids).vicinity_park.pluck(:lng, :lat, :name, :id),
         @parks = Vicinity.find_by(id: vicinity_ids).vicinity_park.page(index_page).per(5)
      else
         @park_area = Vicinity.find_by(id: vicinity_ids).vicinity_park.where(spec: engine_spec).pluck(:lng, :lat, :name, :id),
         @parks = Vicinity.find_by(id: vicinity_ids).vicinity_park.where(spec: engine_spec).page(index_page).per(5)
      end
    end
  end

  # 投稿できる画像を３枚までに制限する
  def validate_number_of_files
    return if images.length <= FILE_NUMBER_LIMIT
    errors.add(:images, "に添付できる画像は#{FILE_NUMBER_LIMIT}件までです。")
  end
  # 金額を検証するメソッド(0円は拒否する)
  def validate_number_of_price
    return if price != PRICE_NUMBER_LIMIT
    errors.add(:price, "を入力してください。")
  end


end
