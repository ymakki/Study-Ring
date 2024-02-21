class Admin::StudyReviewsController < ApplicationController

  before_action :authenticate_admin!

  def index
    @reviews = StudyReview.all
  end

  def show
    @review = StudyReview.includes(:user).find(params[:id])
    @user = @review.user
    @reviews = @user.study_reviews
  end

  def destroy
    @review = StudyReview.find_by(id: params[:id])
    @review.destroy
    redirect_to admin_study_reviews_path
  end

  private

  def study_reviews_params
    params.require(:study_review).permit(:user_id, :study_id, :title, :body)
  end

end
