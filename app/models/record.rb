class Record < ApplicationRecord

  belongs_to :study
  belongs_to :user
  has_many :study_comments, dependent: :destroy

  validates :start_time,presence:true
  validates :study_time,presence:true
  validates :word,presence:true

  has_one_attached :image

end
