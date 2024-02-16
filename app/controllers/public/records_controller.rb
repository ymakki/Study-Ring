class Public::RecordsController < ApplicationController

  before_action :authenticate_user!

  def index
    # フォローしているユーザーにしたい
    @records = Record.all
  end

  def new
    @record = Record.new
    @study = Study.find(params[:study_id])
  end

  def create
    @study = current_user.studies.find(params[:study_id])
    @record = current_user.records.new(record_params.merge(study: @study))

    if @record.save
      redirect_to studies_path, notice: "記録しました"
    else
      render :new
    end
  end

  def show
    @record = Record.find(params[:id])
    @study_comment = @record.study_comments.build
  end

  def edit
    @record = Record.find(params[:id])
    @study = Study.find(params[:study_id])
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
    @study = Study.find(params[:study_id])
    @record = @study.records.find(params[:id])
    @record.destroy
    redirect_to records_path
  end

  private

  def record_params
    params.require(:record).permit(:user_id, :study_id, :start_time, :study_time, :word)
  end

end
