class Public::RecordsController < ApplicationController

  before_action :authenticate_user!

  def index
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

  private

  def record_params
    params.require(:record).permit(:user_id, :study_id, :start_time, :study_time, :word)
  end

end
