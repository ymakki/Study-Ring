class Tag < ApplicationRecord

  has_many :tag_relays, dependent: :destroy
  has_many :studies, through: :tag_relays
  belongs_to :user

end
