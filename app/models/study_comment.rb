class StudyComment < ApplicationRecord
  include Notifiable

  belongs_to :user
  belongs_to :record
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :comment, presence: true

  def notification_message
    "<i class='fa-regular fa-comment'></i>　#{user.name}さんがあなたの勉強記録にコメントしました".html_safe
  end

  def notification_path
    study_record_path(study_id: record.study_id, id: record_id)
  end

  after_create do
    # StudyCommentが属するRecordモデルのuser_idを取得
    if record.present? && record.respond_to?(:user_id)
      build_notification(user_id: record.user_id).save
    end
  end

end
