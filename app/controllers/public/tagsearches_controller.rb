class Public::TagsearchesController < ApplicationController

  def search
    @word = params[:word]
    @records = Study.all
    tag = Tag.find_by(name: @word)
    if tag.present?
      @records = tag.studies
    end
    render "public/tagsearches/result"
  end

end
