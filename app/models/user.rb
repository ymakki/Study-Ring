class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :studies, dependent: :destroy
  has_many :study_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one_attached :profile_image

  # 画像表示
  def get_profile_image(width, height)
    if profile_image.attached?
      profile_image.variant(resize_to_fill: [width, height]).processed
    end
  end

  # ゲストログイン機能
  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
    end
  end

end
