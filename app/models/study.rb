class Study < ApplicationRecord

  belongs_to :user
  belongs_to :tags
  has_many :favorites, dependent: :destroy
  has_one_attached :image

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  # 画像サイズ
  def get_image(width, height)
    image.variant(resize_to_fill: [width, height]).processed
  end

  # 検索
  def self.search_for(word, model)
    Study.where('title LIKE ?', '%' + (word.to_s) + '%')
  end

end
