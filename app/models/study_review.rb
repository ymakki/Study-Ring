class StudyReview < ApplicationRecord
  belongs_to :user
  belongs_to :study
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :title, presence: true,length:{maximum:30}
  validates :body,presence:true,length:{maximum:200}

  # レビュー作成時に各フォロワーに通知を作成
  after_create do
    user.followers.each do |follower|
      build_notification(user_id: follower.id)
      save
    end
  end

end
