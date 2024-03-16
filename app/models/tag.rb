class Tag < ApplicationRecord
  belongs_to :user
  has_many :user_taggings, dependent: :destroy
  has_many :users, through: :user_taggings, dependent: :destroy
  has_many :study_taggings, dependent: :destroy
  has_many :studies, through: :study_taggings, dependent: :destroy

  validates :name, presence: true, length: {maximum: 20}, uniqueness: true
end
