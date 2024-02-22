class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  has_one :notification, as: :notifiable, dependent: :destroy

  # フォローを相手に通知
  after_create do
    build_notification(user_id: followed_id).save
  end

end
