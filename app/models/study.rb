class Study < ApplicationRecord

  # ユーザー
  belongs_to :user

  # カテゴリー
  has_many :tag_relays, dependent: :destroy
  has_many :tags, through: :tag_relays

  # いいね
  has_many :favorites, dependent: :destroy

  # コメント
  has_many :study_comments, dependent: :destroy

  # レコード
  has_many :records, dependent: :destroy

  # 画像
  has_one_attached :image

  # 教材名
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

  # お気に入りか
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

end
