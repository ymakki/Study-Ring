class Timeline < ApplicationRecord
  belongs_to :record, optional: true
  belongs_to :study_review, optional: true
end
