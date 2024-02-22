class Tag < ApplicationRecord

  has_many :user_taggings
  has_many :users, through: :user_taggings

  has_many :study_taggings
  has_many :studies, through: :study_taggings

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
