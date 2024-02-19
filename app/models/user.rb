class User < ApplicationRecord

  # デバイス
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # 教材
  has_many :studies, dependent: :destroy
  # いいね
  has_many :favorites, dependent: :destroy
  has_many :favorited_records, through: :favorites, source: :record
  # コメント
  has_many :study_comments, dependent: :destroy
  # レコード
  has_many :records, dependent: :destroy
  # フォローする
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :relationships, source: :followed
  # フォローされる
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower
  # レビュー
  has_many :study_review, dependent: :destroy
  # メッセージ
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :rooms, through: :entries
  # 画像
  has_one_attached :profile_image

  validates :name,presence:true,length:{maximum:10}

  # 画像サイズ
  def get_profile_image(width, height)
    if profile_image.attached?
      profile_image.variant(resize_to_fill: [width, height]).processed
    end
  end

  # 検索
  def self.search_for(word, model)
    User.where('name LIKE ?', '%' + word + '%')
  end

  # 学習時間
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
    誰でも歓迎: 0,
    知り合い: 1,
    現在募集無し: 2,
  }

  # 性別
  enum sexes: {
    男性: 0,
    女性: 1,
  }

  # 住居地
  enum residences: {
    北海道:0,青森県:1,岩手県:2,宮城県:3,秋田県:4,山形県:5,福島県:6,
    茨城県:7,栃木県:8,群馬県:9,埼玉県:10,千葉県:11,東京都:12,神奈川県:13,
    新潟県:14,富山県:15,石川県:16,福井県:17,山梨県:18,長野県:19,
    岐阜県:20,静岡県:21,愛知県:22,三重県:23,
    滋賀県:24,京都府:25,大阪府:26,兵庫県:27,奈良県:28,和歌山県:29,
    鳥取県:30,島根県:31,岡山県:32,広島県:33,山口県:34,
    徳島県:35,香川県:36,愛媛県:37,高知県:38,
    福岡県:39,佐賀県:40,長崎県:41,熊本県:42,大分県:43,宮崎県:44,鹿児島県:45,
    沖縄県:46,海外:47,
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
