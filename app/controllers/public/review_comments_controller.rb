class Public::ReviewCommentsController < ApplicationController

  def create
    @study_review = StudyReview.find(params[:study_review_id])
    @review_comment = @study_review.review_comments.build(review_comment_params)

    if current_user.present?
      @review_comment.user = current_user
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
    params.require(:review_comment).permit(:comment)
  end

end
