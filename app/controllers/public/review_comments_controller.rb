class Public::ReviewCommentsController < ApplicationController

  def create
    study_review = StudyReview.find(params[:study_review_id])
    if current_user.present?
      @comment = current_user.review_comments.new(review_comment_params)
      @comment.study_review_id = study_review.id
      @comment.save
    end
    redirect_to request.referer
  end

  def destroy
    @comment = StudyReview.find_by(id: params[:id], study_review_id: params[:study_review_id])
    @comment.destroy
    redirect_to request.referer
  end

  private

  def review_comment_params
    params.require(:review_comment).permit(:comment)
  end

end
