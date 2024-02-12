class Tag < ApplicationRecord

  has_many :tag_relay, dependent: :destroy
  has_many :studies, through: :tag_relays

end
