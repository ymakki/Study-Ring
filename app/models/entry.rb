class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :room

  # チャットルームの有無確認
  def self.shared_room_info(user1, user2)
    user1.entries.includes(:room).each do |current_user_entry|
      user2.entries.includes(:room).each do |user_entry|
        if current_user_entry.room_id == user_entry.room_id
          return {
            is_room: true,
            room_id: current_user_entry.room_id
          }
        end
      end
    end
    {
      is_room: false,
      room_id: nil
    }
  end
end
