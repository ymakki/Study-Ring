class ReviewFavorite < ApplicationRecord

  belongs_to :user
  belongs_to :study_review
  has_one :notification, as: :notifiable, dependent: :destroy

  after_create do
    # Favoriteが属するRecordモデルのuser_idを取得
    if study_review.present? && study_review.respond_to?(:user_id)
      build_notification(user_id: study_review.user_id).save
    end
  end

end
