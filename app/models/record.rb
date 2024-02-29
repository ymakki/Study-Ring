class Record < ApplicationRecord

  belongs_to :study
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favoriting_users, through: :favorites, source: :user, dependent: :destroy
  has_many :study_comments, dependent: :destroy

  validates :start_time,presence:true
  validates :study_time, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # いいねしているか？
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
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

end
