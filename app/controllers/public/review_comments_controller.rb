class Public::ReviewCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @study_review = StudyReview.find(params[:study_review_id])
    if @study_review.present?
      @review_comment = @study_review.review_comments.new(review_comment_params)
      @review_comment.user_id = current_user.id
      @review_comment.save
    end
  end

  def destroy
    @study_review = StudyReview.find(params[:study_review_id])
    @review_comment = @study_review.review_comments.find(params[:id])
    @review_comment.destroy
  end

  private

  def review_comment_params
    params.require(:review_comment).permit(:user_id, :study_review_id, :comment)
  end
end
