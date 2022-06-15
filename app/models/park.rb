class Park < ApplicationRecord
  has_many_attached :images
  has_many :comments, dependent: :destroy
  # 新しい順番に表示させる
  has_many :comments, -> { order("created_at desc") },dependent: :destroy
  belongs_to :customer
  has_many :favorites, dependent: :destroy
  has_many :favorite_user, through: :favorites, source: :customer
  has_many :notifications, dependent: :destroy
  has_many :vicinity_parks, dependent: :destroy
  has_many :park_vicinity, through: :vicinity_parks, source: :vicinity

  enum spec: { small: 0, mideam: 1, big: 2, medeamorbig: 3 }
  enum address: { zenniki: 0, Hakata: 1, Chuo: 2 }

  validates :name, presence: true, length: { maximum: 15 }
  validates :purpose, presence: true
  validates :lat, length: { minimum: 4 }
  validates :parking_time, presence: true
  FILE_NUMBER_LIMIT = 3
  validate :validate_number_of_files
  PRICE_NUMBER_LIMIT = 0
  validate :validate_number_of_price

  # scope関連
  scope :filter_address, ->(address) { where('addressOutput LIKE ?', "%#{address}%") }
  scope :filter_content, ->(content) { where('purpose LIKE ?', "%#{content}%") }
  scope :filter_spec, ->(spec) { where(spec: spec) }
  scope :filter_name, ->(content) { where('name LIKE ?', "%#{content}%") }
  # scope(pluck[:lng, :lat, :name, :id]に変換)
  scope :plucks, -> { pluck(:lng, :lat, :name, :id) }

  # そのユーザーが良いねしているか判定
  def user_favorite_by(user)
    favorite_user.exists?(id: user.id)
  end

  def create_notification_like!(user)
    # すでに「いいね」されているか検索
    temp = Notification.where(visitor_id: user.id, visited_id: customer_id,
                              park_id: id, action: 'like')
    if temp.blank?
      notification = user.active_notifications.new(
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
    temp_ids = Comment.select(:customer_id).where(park_id: id).
      where.not(customer_id: current_customer.id).distinct
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

  def sent_vicinity(vicinity, park)
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
  end

  # 投稿内容編集するときのアップデート
  def update_sent_vicinity(vicinity, park)
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
    delete_vicinity = Vicinity.pluck(:id) - VicinityPark.pluck(:vicinity_id)
    Vicinity.where(id: delete_vicinity).destroy_all
  end

  # 投稿削除した時に紐づいてる最寄りの施設が宙にuteいる場合、削除する
  def self.destroy_sent_vicinity
    delete_vicinity = Vicinity.pluck(:id) - VicinityPark.pluck(:vicinity_id)
    Vicinity.where(id: delete_vicinity).destroy_all
  end

  # 詳細検索
  def self.search_for(content, spec, address, index)
    if content.blank?
      filter_place_search(spec, address, index)
    else
      filter_detail_search(content, spec, address, index)
    end
  end

  # 　詳細検索でcontentがからだった場合の処理
  def self.filter_place_search(spec, address, index)
    if spec.blank?
      if address.blank?
        @park_area =
          Park.plucks,
          @parks = Park.page(index).per(5)
      else
        @park_area =
          Park.filter_address(address).plucks,
          @parks = Park.filter_address(address).page(index).per(5)
      end
    else
      if address.blank?
        @park_area =
          Park.filter_spec(spec).plucks,
          @parks = Park.filter_spec(spec).page(index).per(5)
      else
        @park_area =
          Park.filter_spec(spec).filter_address(address).plucks,
          @parks = Park.filter_spec(spec).filter_address(address).page(index).per(5)
      end
    end
  end

  # 詳細検索でcontentがあった場合の処理
  def self.filter_detail_search(content, spec, address, index)
    if spec.blank?
      if address.blank?
        @park_area =
          Park.filter_content(content).or(Park.filter_name(content)).plucks,
          @parks = Park.filter_content(content).page(index).per(5)
      else
        @park_area =
          Park.filter_content(content).or(Park.filter_name(content)).filter_address(address).
            plucks,
          @parks = Park.filter_content(content).filter_address(address).page(index).per(5)
      end
    else
      @park_area =
        Park.filter_content(content).or(Park.filter_name(content)).filter_spec(spec).
          filter_address(address).
          plucks,
        @parks = Park.filter_content(content).
          filter_spec(engine_spec).
          filter_address(address).
          page(index).per(5)
    end
  end

  # 最寄り検索した場合のメソッド
  def self.search_for_vicinity(vicinity_ids, spec, index)
    if vicinity_ids.blank?
      if spec.blank?
        @park_area =
          Park.plucks,
          @parks = Park.page(index).per(5)
      else
        @park_area =
          Park.where(spec: spec).plucks,
          @parks = Park.where(spec: spec).page(index).per(5)
      end
    else
      if spec.blank?
        @park_area =
          Vicinity.find_by(id: vicinity_ids).vicinity_park.plucks,
          @parks = Vicinity.find_by(id: vicinity_ids).vicinity_park.page(index).per(5)
      else
        @park_area =
          Vicinity.find_by(id: vicinity_ids).vicinity_park.where(spec: spec).plucks,
          @parks = Vicinity.find_by(id: vicinity_ids).vicinity_park.
            where(spec: spec).page(index).per(5)
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
