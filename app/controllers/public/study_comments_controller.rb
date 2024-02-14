class Public::StudyCommentsController < ApplicationController

  def create
    study = Study.find(params[:study_id])
    comment = current_user.study_comments.new(study_comment_params)
    comment.study_id = study.id
    comment.save
    redirect_to request.referer
  end

  private

  def study_comment_params
    params.require(:study_comment).permit(:comment)
  end

end
