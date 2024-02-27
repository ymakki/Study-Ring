class Public::RecordsController < ApplicationController

  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @record = Record.new
    @study = Study.find(params[:study_id])
  end

  def index
    # フォローしているユーザーのID一覧を取得
    followed_user_ids = current_user.following.pluck(:id)
    # フォローしているユーザーと自身のレコードとレビューを取得
    @timelines = Timeline.where(user_id: [current_user.id] + followed_user_ids).order(created_at: :desc)
  end

  def create
    # 自身の教材に勉強記録を保存
    @study = current_user.studies.find(params[:study_id])
    @record = current_user.records.new(record_params.merge(study: @study))

    if @record.save
      # レコードをタイムラインモデルに保存
      Timeline.create(user_id: current_user.id, record_id: @record.id, created_at: @record.created_at)
      redirect_to studies_path, notice: "記録しました"
    else
      render :new
    end
  end

  def show
    @record = Record.find(params[:id])
    @user = @record.user
    @study = @record.study
    @study_comment = @record.study_comments.build
  end

  def edit
    @record = Record.find(params[:id])
    @study = @record.study
  end

  def update
    @record = Record.find(params[:id])
    if @record.update(record_params)
      redirect_to study_record_path(@record), notice: "更新しました"
    else
      render "show"
    end
  end

  def destroy
    @record = Record.find(params[:id])
    @record.destroy
    redirect_to records_path
  end

  private

  def record_params
    params.require(:record).permit(:user_id, :study_id, :start_time, :study_time, :word)
  end

  def ensure_correct_user
    record = Record.find(params[:id])
    unless record.user == current_user
      redirect_to records_path
    end
  end

end
