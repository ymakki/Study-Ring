class StudyTagging < ApplicationRecord
  belongs_to :study
  belongs_to :tag
end
