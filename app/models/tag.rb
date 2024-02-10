class Tag < ApplicationRecord

  has_many :studies, dependent: :destroy
  has_many :users, dependent: :destroy
  validates :name, presence: true, uniqueness: true, length: {in: 2..20}

end
