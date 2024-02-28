class Public::TagsearchesController < ApplicationController

  def search
    @user = User.find(params[:user_id])
    @word = params[:tag_id]

    tag = Tag.find_by(name: @word)
    if tag.present?
      # 関連する Tag レコードを組み合わせてtags テーブルの id カラムが指定された tag.id と一致するレコードを取得
      @records = Study.joins(:tags).where(tags: { id: tag.id })
    else
      @records = []
    end

    render "public/tagsearches/result"
  end

end
