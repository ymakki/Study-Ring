class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :content, presence: true, length: { maximum:140 }

  # フォロワーに通知
  after_create do
    user.followers.each do |follower|
      user.notifications.create(user_id: follower.id)
    end
  end

end
