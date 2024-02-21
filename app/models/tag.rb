class Tag < ApplicationRecord

  has_many :tag_relays, dependent: :destroy
  has_many :studies, through: :tag_relays
  belongs_to :user

  # 重複したタグを削除
  def self.unify_duplicate_tags
    duplicated_tags = Tag.group(:name).having('count(*) > 1').pluck(:name)

    duplicated_tags.each do |name|
      tags_to_unify = Tag.where(name: name)
      tags_to_unify.drop(1).each do |tag|
        tag.destroy
      end
    end
  end

end
