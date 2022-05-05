class Park < ApplicationRecord
  has_many_attached :images
  # has_many_attached :image
  has_many:comments,dependent: :destroy
  belongs_to:customer
  has_many:favorites,dependent: :destroy
  has_many:favorite_user,through: :favorites,source: :customer

  has_many:notifications,dependent: :destroy

  enum spec: { small: 0, mideam: 1, big: 2, medeamorbig: 3 }

  validates :name,presence: true
  validates :price,presence: true
  validates :purpose,presence: true
  validates :lat,length: { minimum: 4}


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
      # 自分の投稿を良いねした場合の処理
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      # もしバリデーションに引っ掛からなかったら。セーブする
      notification.save if notification.valid?
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
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

end
