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
  end

  def destroy
    @record = Record.find(params[:id])
    @record.destroy
    redirect_to study_records_path
  end

  private

  def record_params
    params.require(:record).permit(:user_id, :start_time, :study_time, :word)
  end

  def ensure_correct_user
    study = Study.find(params[:id])
    unless study.user == current_user
      redirect_to studies_path
    end
  end

end
