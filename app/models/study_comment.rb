class StudyComment < ApplicationRecord

  belongs_to :user
  belongs_to :study

  validates :comment, presence: true

end
