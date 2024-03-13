class Admin::ReviewCommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @review_comments = ReviewComment.includes(:user).all
  end

  def destroy
    @review_comment = ReviewComment.find_by(id: params[:id])
    @review_comment.destroy
    redirect_to admin_review_comments_path
  end

  private

  def review_comment_params
    params.require(:review_comment).permit(:user_id, :study_review_id, :comment)
  end
end
