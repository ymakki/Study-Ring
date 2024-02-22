class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :content, presence: true, length: { maximum:140 }

  # フォロワーに通知
  after_create do
    # Messageテーブルから、現在の発言したroom_idに関連するユーザーの発言を全件取得し、
    # 配列で、user_idをpluckで取得した後、調布魔をuniq!で取り除く
    room_user = Message.where(room_id: room_id).pluck(:user_id).uniq!
    room_user.each do |user|
      build_notification(user_id: user) # 配列のぶんだけ、ユーザーの通知作成
      save
    end

  end

end
