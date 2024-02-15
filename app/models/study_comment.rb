class StudyComment < ApplicationRecord

  belongs_to :user
  belongs_to :study
  belongs_to :record

  validates :comment, presence: true

end
