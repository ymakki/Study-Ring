class User < ApplicationRecord

  # デバイス
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # 教材
  has_many :studies, dependent: :destroy
  # いいね
  has_many :favorites, dependent: :destroy
  has_many :favorited_records, through: :favorites, source: :record, dependent: :destroy
  has_many :review_favorites, dependent: :destroy
  has_many :favorited_study_reviews, through: :review_favorites, source: :study_review, dependent: :destroy
  # コメント
  has_many :study_comments, dependent: :destroy
  has_many :review_comments, dependent: :destroy
  # 記録
  has_many :records, dependent: :destroy
  # フォローする
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :relationships, source: :followed, dependent: :destroy
  # フォローされる
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower, dependent: :destroy
  # レビュー
  has_many :study_reviews, dependent: :destroy
  # メッセージ
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :rooms, through: :entries
  # タグ
  has_many :user_taggings, dependent: :destroy
  has_many :tags, through: :user_taggings, dependent: :destroy
  # 通知
  has_many :notifications, dependent: :destroy

  has_one_attached :profile_image
  validates :name,presence:true,length:{maximum:10}
  validates :profile_image, content_type: [:png, :jpg, :jpeg]

  # 画像サイズ(画像のアスペクト比を維持)
  def get_profile_image(width, height)
    if profile_image.attached?
      profile_image.variant(resize_to_fill: [width, height]).processed
    end
  end

  # 検索
  def self.search_for(word, model)
    User.where('name LIKE ?', '%' + word + '%')
  end

  # 学習の合計時間
  def total_study_time
    total_minutes = records.sum(:study_time)
    days = total_minutes / (60 * 24)
    hours = (total_minutes % (60 * 24)) / 60
    minutes = total_minutes % 60

    "#{days}日 #{hours}時間 #{minutes}分"
  end

  # フォローする
  def follow(user)
    relationships.create(followed_id: user.id)
  end

  # フォローを外す
  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  # フォローしているか
  def following?(user)
    following.include?(user)
  end

  # 募集状態
  enum follow_requests: {
    welcome: 0,
    acquaintance: 1,
    no_recruitment: 2
  }

  # 性別
  enum sexes: {
    man: 0,
    woman: 1,
  }

  # 住居地
  enum residences: {
    hokkaido:0, aomori:1, iwate:2, miyagi:3, akita:4, yamagata:5, fukushima:6,
    ibaraki:7, tochigi:8, gunma:9, saitama:10, chiba:11, tokyo:12, kanagawa:13,
    niigata:14, toyama:15, ishikawa:16, fukui:17, yamanashi:18, nagano:19,
    gifu:20, shizuoka:21, aichi:22, mie:23,
    shiga:24, kyoto:25, osaka:26, hyogo:27, nara:28, wakayama:29,
    tottori:30, shimane:31, okayama:32, hiroshima:33, yamaguchi:34,
    tokushima:35, kagawa:36, ehime:37, kochi:38,
    fukuoka:39, saga:40, nagasaki:41, kumamoto:42, oita:43, miyazaki:44, kagoshima:45,
    okinawa:46, overseas:47
   }

  # ゲストログイン
  GUEST_USER_EMAIL = "guest@example.com"
  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
    end
  end

  # ゲスト判別
  def guest_user?
    email == GUEST_USER_EMAIL
  end
end
