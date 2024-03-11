class Public::ReviewFavoritesController < ApplicationController

  def create
    @study_review = StudyReview.find(params[:study_review_id])
    favorite = current_user.review_favorites.new(study_review_id: @study_review.id)
    favorite.save
  end

  def destroy
    @study_review = StudyReview.find(params[:study_review_id])
    favorite = current_user.review_favorites.find_by(study_review_id: @study_review.id)
    favorite.destroy
  end

end
