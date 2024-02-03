class Study < ApplicationRecord

  belongs_to :user
  belongs_to :tag
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_one_attached :image

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def get_image
    (image.attached?) ? image : 'default_image.jpg'
  end

end
