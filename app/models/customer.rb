class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many:comments,dependent: :destroy
  has_many:parks
  has_many:favorites,dependent: :destroy
  has_many:favorite_park,through: :favorites,source: :park
  has_one_attached:bike_image

  validates :name,presence: true

  def get_bike_image(width,height)
    unless bike_image.attached?
      file_path = Rails.root.join("app/assets/images/harley-g79ab8bdd0_1920.jpg")
      bike_image.attach(io:File.open(file_path),filename:"default-image.jpg",content_type:"image/jpeg")
    end
      bike_image.variant(resize_to_limit:[width,height]).processed
  end

end
