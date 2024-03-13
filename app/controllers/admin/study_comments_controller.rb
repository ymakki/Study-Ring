class Admin::StudyCommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @study_comments = StudyComment.includes(:user).all
  end

  def destroy
    @study_comment = StudyComment.find_by(id: params[:id])
    @study_comment.destroy
    redirect_to admin_study_comments_path
  end

  private

  def study_comment_params
    params.require(:study_comment).permit(:user_id, :record_id, :comment)
  end
end
