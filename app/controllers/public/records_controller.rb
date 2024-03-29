class Public::RecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @record = Record.new
    @study = Study.find(params[:study_id])
  end

  def create
    # 自身の教材に勉強記録を保存
    @study = current_user.studies.find(params[:study_id])
    @record = current_user.records.new(record_params)
    @record.study_id = @study.id

    if @record.save
      # レコードをタイムラインモデルに保存
      Timeline.create(user_id: current_user.id, record_id: @record.id, created_at: @record.created_at)
      flash[:success] = "記録しました"
      redirect_to studies_path
    else
      render "new"
    end
  end

  def show
    @record = Record.find(params[:id])
    @user = @record.user
    @study = @record.study
    @study_comment = StudyComment.new(record: @record)
  end

  def edit
    @record = Record.find(params[:id])
    @study = @record.study
  end

  def update
    @record = Record.find(params[:id])
    if @record.update(record_params)
      flash[:success] = "更新しました"
      redirect_to study_record_path(@record)
    else
      @study = @record.study
      render "edit"
    end
  end

  def destroy
    @record = Record.find(params[:id])
    @record.destroy
    redirect_to timelines_path
  end

  private

  def record_params
    params.require(:record).permit(:user_id, :study_id, :start_time, :study_time, :word)
  end

  def ensure_correct_user
    record = Record.find(params[:id])
    unless record.user == current_user
      redirect_to timelines_path
    end
  end
end
