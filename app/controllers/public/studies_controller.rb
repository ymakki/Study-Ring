class Public::StudiesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @studies = current_user.studies
  end

  def new
    @study = Study.new
  end

  # 自分の本棚に保存
  def copy
    # dup: 複製
    @original = Study.find(params[:study_id])
    copy = @original.dup
    copy.user_id = current_user.id
    copy.image.attach(@original.image.blob)
    if copy.save
      flash[:success] = "本棚に登録しました"
      redirect_to studies_path
    else
      flash[:danger] = "登録に失敗しました"
      redirect_to study_path(@original)
    end
  end

  def create
    @study = current_user.studies.new(study_params)

    if @study.save
      flash[:success] = "保存しました"
      redirect_to studies_path
    else
      render "new"
    end
  end

  def show
    @study = Study.includes(:user, :study_reviews).find(params[:id])
    @user = @study.user
    @study_reviews = @study.study_reviews.all
  end

  def edit
    @study = Study.find(params[:id])
  end

  def update
    @study = Study.find(params[:id])
    if @study.update(study_params)
      flash[:success] = "更新しました"
      redirect_to studies_path
    else
      render "edit"
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
    user_studies = current_user.studies
    statuses = Study.statuses

    case sort_type
      when 'now'
        @studies = user_studies.where(status: statuses[:now])
      when 'stay'
        @studies = user_studies.where(status: statuses[:stay])
      when 'finish'
        @studies = user_studies.where(status: statuses[:finish])
    end

    render "index"
  end

  private

  def study_params
    params.require(:study).permit(:user_id, :title, :status, :image, tag_ids: [])
  end

  def ensure_correct_user
    study = Study.find(params[:id])
    unless study.user == current_user
      redirect_to studies_path
    end
  end
end
