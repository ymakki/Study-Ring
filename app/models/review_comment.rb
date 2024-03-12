class ReviewComment < ApplicationRecord
  include Notifiable

  belongs_to :user
  belongs_to :study_review
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :comment, presence: true

  def notification_message
    "<i class='fa-regular fa-comment'></i>　#{user.name}さんがあなたのレビューにコメントしました".html_safe
  end

  def notification_path
    study_study_review_path(study_id: study_review.study_id, id: study_review_id)
  end

  after_create do
    # StudyCommentが属するRecordモデルのuser_idを取得
    if study_review.present? && study_review.respond_to?(:user_id)
      build_notification(user_id: study_review.user_id).save
    end
  end
end