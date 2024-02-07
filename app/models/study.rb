class Study < ApplicationRecord

  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one_attached :image

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  # 画像サイズ
  def get_image(width, height)
    image.variant(resize_to_fill: [width, height]).processed
  end

  # enumステータス
  enum status: {
    studying: 0,
    stand_by: 1,
    finish: 2,
  }

end
