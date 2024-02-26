class StudyReview < ApplicationRecord
  belongs_to :user
  belongs_to :study
  has_many :review_favorites, dependent: :destroy
  has_many :favoriting_users, through: :review_favorites, source: :user
  has_many :review_comments, dependent: :destroy
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :title, presence: true,length:{maximum:30}
  validates :body,presence:true,length:{maximum:200}

  # いいねしているか？
  def favorited_by?(user)
    review_favorites.where(user_id: user.id).exists?
  end

  # いいねしたユーザーを１０人表示(新しい順に更新)
  def add_favoriting_user(user)
    return if favoriting_users.include?(user)

    # ユーザーが10人以上なら最も古いものを削除
    if favoriting_users.count >= 10
      oldest_user = favoriting_users.order(created_at: :asc).first
      favoriting_users.delete(oldest_user)
    end

    favoriting_users << user
  end

  # レビュー作成時に各フォロワーに通知を作成
  after_create do
    user.followers.each do |follower|
      notification = follower.notifications.build(notifiable: self)
      notification.save
    end
  end

end
