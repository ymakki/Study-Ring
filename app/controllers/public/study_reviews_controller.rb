class Public::StudyReviewsController < ApplicationController

  def new
    @review = StudyReview.new
    @study = Study.find(params[:study_id])
  end

  def index
  end

  def create
    study = Study.find(params[:study_id])
    review = current_user.study_review.new(study_reviews_params)
    review.study_id = study.id
    review.save

    reviews = StudyReview.where(user_id: current_user.id)
    reviews.each do |review|
      Timeline.create(user_id: current_user.id, study_review_id: review.id, created_at: review.created_at)
    end

    redirect_to study_path(study)
  end

  def show

  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def study_reviews_params
    params.require(:study_review).permit(:user_id, :study_id, :title, :body)
  end

end
