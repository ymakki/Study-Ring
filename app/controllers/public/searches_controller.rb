class Public::SearchesController < ApplicationController


  def search
    @search_type = params[:search_type]

    @studies = Study.all
    @users = User.all

    @word = params[:word]
    @model = params[:model]
    if @model == "user"
      @records = User.search_for(@word, @model)
    else
      @records = Study.search_for(@word, @model)
    end
  end

end
