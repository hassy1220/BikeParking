class Park < ApplicationRecord
  has_one_attached :image
  # has_many_attached :image
  has_many:comments,dependent: :destroy
  belongs_to:customer
  has_many:favorites,dependent: :destroy
  has_many:favorite_user,through: :favorites,source: :customer
  enum spec: { small: 0, mideam: 1, big: 2, medeamorbig: 3 }

  validates :name,presence: true
  validates :price,presence: true
  validates :purpose,presence: true
  validates :lat,length: { minimum: 4}
  validates :lng,length: { minimum: 4}

  def get_image(width,height)
    unless image.attached?
      file_path = Rails.root.join("app/assets/images/parking-space-g37442e9c0_1280.jpg")
      image.attach(io:File.open(file_path),filename:"default-image.jpg",content_type:"image/jpeg")
    end
      image.variant(resize_to_limit:[width,height]).processed
  end

   #そのユーザーが良いねしているか判定
  def user_favorite_by(user)
    favorite_user.exists?(id: user.id)
  end

end
