class Public::StudyCommentsController < ApplicationController

  def create
    record = Record.find(params[:record_id])
    if current_user.present?
      @comment = current_user.study_comments.new(study_comment_params)
      @comment.record_id = record.id
      @comment.save
    end
    redirect_to request.referer
  end

  def destroy
    @comment = StudyComment.find_by(id: params[:id], record_id: params[:record_id])
    @comment.destroy
    redirect_to request.referer
  end

  private

  def study_comment_params
    params.require(:study_comment).permit(:comment)
  end

end
