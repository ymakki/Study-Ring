class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @search_type = params[:search_type]
    @studies = Study.where.not(user_id: current_user.id)
    @users = User.where.not(id: current_user.id)

    @word = params[:word]
    @model = params[:model]
    if @model == "user"
      @records = User.search_for(@word, @model)
    else
      @records = Study.search_for(@word, @model)
    end
  end
end
