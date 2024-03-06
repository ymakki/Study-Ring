class Admin::StudyCommentsController < ApplicationController

  before_action :authenticate_admin!

  def index
    @comments = StudyComment.includes(:user).all
    @review_comments = ReviewComment.includes(:user).all
  end

  def destroy
    @comment = StudyComment.find_by(id: params[:id])
    @review_comment = ReviewComment.find_by(id: params[:id])

    @comment&.destroy
    @review_comment&.destroy

    redirect_to admin_study_comments_path
  end

  private

  def study_comment_params
    params.require(:study_comment).permit(:comment)
  end

end
