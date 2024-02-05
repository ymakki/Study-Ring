class Tag < ApplicationRecord

  has_many :studies, dependent: :destroy

end
