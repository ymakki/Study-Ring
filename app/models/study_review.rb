class StudyReview < ApplicationRecord

  belongs_to :user
  belongs_to :study

  validates :title, presence: true,length:{maximum:30}
  validates :body,presence:true,length:{maximum:200}

end
