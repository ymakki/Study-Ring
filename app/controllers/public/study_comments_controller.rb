class Public::StudyCommentsController < ApplicationController

  def create
    @record = Record.find(params[:record_id])
    @study_comment = @record.study_comments.build(study_comment_params)

    if current_user.present?
      @study_comment.user = current_user
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
    params.require(:study_comment).permit(:comment)
  end

end
