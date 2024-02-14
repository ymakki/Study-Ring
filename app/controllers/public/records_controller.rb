class Public::RecordsController < ApplicationController

  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:destroy]

  def index
    @study = Study.new
    @studies = current_user.studies
  end

  def new
    @record = Record.new
    @study = Study.find(params[:study_id])
  end

  def create
    @record = current_user.studies.new(record_params)

    if @study.save
      redirect_to study_path(@study), notice: "記録しました"
    else
      @tags = Tag.all
      render "new"
    end
  end

  def show
    @study = Study.find(params[:id])
    @study_comment = StudyComment.new
  end

  def edit
    @study = Study.find(params[:id])
    @tags = Tag.all
  end

  def update
    @study = Study.find(params[:id])
    if @study.update(study_params)
      redirect_to study_path(@study), notice: "更新しました"
    else
      @tags = Tag.all
      render "show"
    end
  end

  def destroy
    @study = Study.find(params[:id])
    @study.destroy
    redirect_to studies_path
  end

  def record
    @study = Study.find(params[:id])
    @user = User.find(params[:id])
    @study_comment = StudyComment.new
  end

  private

  def study_params
    params.require(:study).permit(:user_id, :start_time, :study_time, :word)
  end

  def ensure_correct_user
    study = Study.find(params[:id])
    unless study.user == current_user
      redirect_to studies_path
    end
  end

end
