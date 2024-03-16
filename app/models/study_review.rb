class StudyReview < ApplicationRecord
  include Notifiable

  belongs_to :user
  belongs_to :study
  has_many :review_favorites, dependent: :destroy
  has_many :favoriting_users, through: :review_favorites, source: :user, dependent: :destroy
  has_many :review_comments, dependent: :destroy
  has_many :notification, as: :notifiable, dependent: :destroy

  validates :title, presence: true, length: {maximum: 30}
  validates :body, presence: true, length: {maximum: 200}

  # いいねしているか？
  def favorited_by?(user)
    review_favorites.where(user_id: user.id).exists?
  end

  # いいねしたユーザーを表示
  def add_favoriting_user(user)
    return if favoriting_users.include?(user)
    favoriting_users << user
  end

  def notification_message
    "<i class='fa-solid fa-book-open'></i>　#{user.name}さんがレビューを投稿しました".html_safe
  end

  def notification_path
    study_study_review_path(id: self.id, study_id: self)
  end

  # レビュー作成時に各フォロワーに通知を作成
  after_create do
    records = user.followers.map do |follower|
      Notification.new(user_id: follower.id, notifiable: self)
    end
    Notification.import records
  end
end
