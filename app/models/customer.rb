class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :comments, dependent: :destroy
  has_many :parks
  has_many :favorites, dependent: :destroy
  has_many :favorite_park, through: :favorites, source: :park

  # 　自分はたくさんの通知を持っている
  has_many :active_notifications, class_name: :Notification,
                                  foreign_key: :visitor_id, dependent: :destroy
  # 相手もたくさんの通知を持っている
  has_many :passive_notifications, class_name: :Notification,
                                   foreign_key: :visited_id, dependent: :destroy

  # フォロー本人目線
  has_many :relationships, class_name: "Relationship",
                           foreign_key: "follow_id", dependent: :destroy
  # フォローされた人目線
  has_many :reverse_of_relationships, class_name: "Relationship",
                                      foreign_key: "follower_id", dependent: :destroy

  # フォロー本人目線でフォローしている人一覧
  has_many :follow_user, through: :relationships, source: :follower
  # フォローされた人目線でフォローしている人一覧
  has_many :follower_user, through: :reverse_of_relationships, source: :follow

  has_one_attached :bike_image
  has_many_attached :my_bike_images
  validates :name, presence: true
  FILE_NUMBER_LIMIT = 3
  validate :validate_number_of_files

  def self.guest
    find_or_create_by!(name: 'guestuser', email: 'guest@example.com') do |customer|
      customer.password = SecureRandom.urlsafe_base64
      customer.name = "guestuser"
    end
  end

  # is_deletedがfalseならtrueを返すようにしている
  def active_for_authentication?
    super && (is_deleted == false)
  end

  # カスタマーのプロフィール画像を表示させるメソッド
  def get_bike_image(width, height)
    unless bike_image.attached?
      file_path = Rails.root.join("app/assets/images/my_page.jpg")
      bike_image.attach(io: File.open(file_path), filename: "image.jpg", content_type: "image/jpeg")
    end
    bike_image.variant(resize_to_limit: [width, height]).processed
  end

  # 会員が退会しているかどうか
  def customer_status
    if is_deleted == false
      "有効"
    else
      "退会"
    end
  end

  def follow_user_by(user)
    follower_user.exists?(id: user.id)
  end

  def create_notification_follow!(current_customer)
    temp = Notification.where(visitor_id: current_customer.id, visited_id: id, action: 'follow')
    if temp.blank?
      notification = current_customer.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  # 投稿できる画像を３枚までに制限する
  def validate_number_of_files
    return if my_bike_images.length <= FILE_NUMBER_LIMIT
    errors.add(:images, "に添付できる画像は#{FILE_NUMBER_LIMIT}件までです。")
  end
end
