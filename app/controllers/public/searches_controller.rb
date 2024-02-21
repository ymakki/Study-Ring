class Public::SearchesController < ApplicationController


  def search
    @search_type = params[:search_type]

    @studies = Study.all
    @studies = @studies.where.not(user_id: current_user.id) if current_user.present?

    @users = User.all
    @users = @users.where.not(id: current_user.id) if current_user.present?

    @word = params[:word]
    @model = params[:model]
    if @model == "user"
      @records = User.search_for(@word, @model)
    else
      @records = Study.search_for(@word, @model)
    end
  end

end
