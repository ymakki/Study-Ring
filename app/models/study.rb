class Study < ApplicationRecord
  belongs_to :user
  has_many :study_taggings, dependent: :destroy
  has_many :tags, through: :study_taggings, dependent: :destroy
  has_many :records, dependent: :destroy
  has_many :study_reviews, dependent: :destroy
  has_one_attached :image

  validates :title, presence:true
  validates :image, content_type: [:png, :jpg, :jpeg]

  # ステータス
  enum statuses: {
    now: 0,
    stay: 1,
    finish: 2
  }

  # 画像サイズ(画像のアスペクト比を維持)
  def get_image(width, height)
    image.variant(resize_to_fit: [width, height]).processed
  end

  # 検索
  def self.search_for(word, model)
    Study.where("title LIKE ?", "%" + (word.to_s) + "%")
  end

  # レビューのいいね数カウント
  def total_review_favorites
    # 二重配列をひとつずつ合計
    study_reviews.sum { |study_review| study_review.review_favorites.count }
  end
end
