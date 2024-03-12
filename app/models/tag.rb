class Tag < ApplicationRecord
  belongs_to :user
  has_many :user_taggings, dependent: :destroy
  has_many :users, through: :user_taggings, dependent: :destroy
  has_many :study_taggings, dependent: :destroy
  has_many :studies, through: :study_taggings, dependent: :destroy

  validates :name,presence:true,length:{maximum:20}

  # 重複したタグを削除
  def self.unify_duplicate_tags
    # nameが重複しているデータを各グループ毎に取得
    duplicated_tags = Tag.group(:name).having('count(*) > 1').pluck(:name)

    # ひとつを残して他全てを削除
    duplicated_tags.each do |name|
      tags_to_unify = Tag.where(name: name)
      tags_to_unify.drop(1).each do |tag|
        tag.destroy
      end
    end
  end

end
