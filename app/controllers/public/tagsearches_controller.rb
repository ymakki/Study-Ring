class Public::TagsearchesController < ApplicationController

  def search
    @user = User.find(params[:user_id])
    @word = params[:tag_id]

    tag = Tag.find_by(name: @word)
    if tag.present?
      @records = @user.studies.where(id: tag.studies.pluck(:id))
    else
      @records = []
    end

    render "public/tagsearches/result"
  end

end
