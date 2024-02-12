class Public::StudiesController < ApplicationController

  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @studies = current_user.studies
    @study = Study.new
  end

  def new
    @study = Study.new
    @tags = Tag.all
  end

  def create
    @study = current_user.studies.new(study_params)

    if @study.save
      redirect_to study_path(@study), notice: "記録しました"
    else
      @tags = Tag.all
      render "new"
    end
  end

  def show
    @study = Study.find(params[:id])
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
