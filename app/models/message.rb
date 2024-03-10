class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :content, presence: true, length: { maximum:140 }

  # Message作成時に相手に通知
  after_create do
    # room_idが同じのuser_idが違うuserを取得
    entries = Entry.where(room_id: room_id).where.not(user_id: user_id)
    entries.each do |entry|
      build_notification(user_id: entry.user_id).save
    end
  end

end
