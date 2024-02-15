class Record < ApplicationRecord

  belongs_to :study
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :study_comments, dependent: :destroy

  validates :start_time,presence:true
  validates :study_time,presence:true
  validates :word,presence:true

  # いいね
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

end
