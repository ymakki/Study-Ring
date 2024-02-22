class Study < ApplicationRecord

  # ユーザー
  belongs_to :user
  # タグ
  has_many :study_taggings
  has_many :tags, through: :study_taggings
  # 記録
  has_many :records, dependent: :destroy
  # レビュー
  has_many :study_reviews, dependent: :destroy

  has_one_attached :image
  validates :title,presence:true

  # ステータス
  enum statuses: {
    勉強中: 0,
    スタンバイ: 1,
    完了済み: 2,
  }

  # 画像サイズ
  def get_image(width, height)
    image.variant(resize_to_fill: [width, height]).processed
  end

  # 検索
  def self.search_for(word, model)
    Study.where("title LIKE ?", "%" + (word.to_s) + "%")
  end

end
