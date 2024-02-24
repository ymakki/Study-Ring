class StudyComment < ApplicationRecord
  belongs_to :user
  belongs_to :record
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :comment, presence: true

  after_create do
    # StudyCommentが属するRecordモデルのuser_idを取得
    if record.present? && record.respond_to?(:user_id)
      build_notification(user_id: record.user_id).save
    end
  end

end
