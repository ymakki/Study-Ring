class Relationship < ApplicationRecord
  include Notifiable

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  has_one :notification, as: :notifiable, dependent: :destroy

  def notification_message
    "<i class='fa-regular fa-handshake'></i>　#{follower.name}さんがあなたをフォローしました".html_safe
  end

  def notification_path
    user_path(follower_id)
  end

  # フォローを相手に通知
  after_create do
    build_notification(user_id: followed_id).save
  end
end
