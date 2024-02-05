class Public::StudiesController < ApplicationController

  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @studies = Study.all
    @study = Study.new
  end

  def new
  end

  def create
    @study = Study.new(study_params)
    @Study.user_id = current_user.id
    if @study.save
      redirect_to study_path(@study), notice: "記録しました"
    else
      render 'new'
    end
  end

  def show
    @study = Study.find(params[:id])
  end

  def edit
  end

  def update
    if @study.update(study_params)
      redirect_to study_path(@study), notice: "更新しました"
    else
      render "show"
    end
  end

  def destroy
    @study.destroy
    redirect_to studies_path
  end

  private

  def study_params
    params.require(:study).permit(:title, :body, :status)
  end

  def ensure_correct_user
    @study = Study.find(params[:id])
    unless @study.user == current_user
      redirect_to studies_path
    end
  end

end
