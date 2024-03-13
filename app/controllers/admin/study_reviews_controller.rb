class Admin::StudyReviewsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @study_reviews = StudyReview.includes(:user).all
  end

  def destroy
    @study_review = StudyReview.find_by(id: params[:id])
    @study_review.destroy
    redirect_to admin_study_reviews_path
  end

  private

  def study_review_params
    params.require(:study_review).permit(:user_id, :study_id, :title, :body)
  end
end
