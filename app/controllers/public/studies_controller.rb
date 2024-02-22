class Public::StudiesController < ApplicationController

  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @studies = current_user.studies
  end

  def new
    @study = Study.new
    @study_copy = Study.new(title: params[:title])
  end

  def create
    @study = current_user.studies.new(study_params)

    if @study.save
      redirect_to studies_path, notice: "記録しました"
    else
      render "new"
    end
  end

  def show
    @study = Study.includes(:user, :study_reviews).find(params[:id])
    @user = @study.user
    @reviews = @study.study_reviews.all
  end

  def edit
    @study = Study.find(params[:id])
  end

  def update
    @study = Study.find(params[:id])
    if @study.update(study_params)
      redirect_to study_path(@study), notice: "更新しました"
    else
      render "show"
    end
  end

  def destroy
    @study = Study.find(params[:id])
    @study.destroy
    redirect_to studies_path
  end

  # ソート
  def sort
    sort_type = params[:sort_type]

    case sort_type
    when 'now'
      @studies = current_user.studies.where(status: Study.statuses[:勉強中])
    when 'stay'
      @studies = current_user.studies.where(status: Study.statuses[:スタンバイ])
    when 'finish'
      @studies = current_user.studies.where(status: Study.statuses[:完了済み])
    end

    render "index"
  end

  private

  def study_params
    params.require(:study).permit(:user_id, :title, :body, :status, :image, tag_ids: [])
  end

  def ensure_correct_user
    study = Study.find(params[:id])
    unless study.user == current_user
      redirect_to studies_path
    end
  end

end
