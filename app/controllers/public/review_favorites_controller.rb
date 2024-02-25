class Public::ReviewFavoritesController < ApplicationController

  def create
    @review = StudyReview.find(params[:study_review_id])
    favorite = current_user.review_favorites.new(study_review_id: @review.id)
    favorite.save
  end

  def destroy
    @review = StudyReview.find(params[:study_review_id])
    favorite = current_user.review_favorites.find_by(study_review_id: @review.id)
    favorite.destroy
  end

end
