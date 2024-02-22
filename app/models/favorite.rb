class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :record
  has_one :notification, as: :notifiable, dependent: :destroy

  # フォロワーに通知
  after_create do
    user.followers.each do |follower|
      build_notification(user_id: follower.id)
      save
    end
  end

end
