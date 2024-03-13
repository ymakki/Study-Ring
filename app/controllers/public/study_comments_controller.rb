class Public::StudyCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @record = Record.find(params[:record_id])
    if @record.present?
      @study_comment = @record.study_comments.new(study_comment_params)
      @study_comment.user_id = current_user.id
      @study_comment.save
    end
  end

  def destroy
    @record = Record.find(params[:record_id])
    @study_comment = @record.study_comments.find(params[:id])
    @study_comment.destroy
  end

  private

  def study_comment_params
    params.require(:study_comment).permit(:user_id, :record_id, :comment)
  end
end
