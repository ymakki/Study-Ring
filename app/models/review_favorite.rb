class ReviewFavorite < ApplicationRecord
  include Notifiable

  belongs_to :user
  belongs_to :study_review
  has_one :notification, as: :notifiable, dependent: :destroy

  def notification_message
    "<i class='fa-regular fa-thumbs-up'></i>　#{user.name}さんがあなたのレビューにいいね！と言っています".html_safe
  end

  def notification_path
    user_path(user_id)
  end

  after_create do
    # Favoriteが属するRecordモデルのuser_idを取得
    if study_review.present? && study_review.respond_to?(:user_id)
      build_notification(user_id: study_review.user_id).save
    end
  end

end
