class Public::TagsearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @tag = Tag.find_by(name: params[:tag_id])
    # studyが持つtag_ids配列からtag.idが一致するstudyを取得
    @records = Study.joins(:tags).where(tags: { id: @tag.id })
    render "public/tagsearches/result"
  end
end