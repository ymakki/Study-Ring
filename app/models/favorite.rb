class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :record
  has_one :notification, as: :notifiable, dependent: :destroy

  after_create do
    # Favoriteが属するRecordモデルのuser_idを取得
    if record.present? && record.respond_to?(:user_id)
      build_notification(user_id: record.user_id).save
    end
  end

end
