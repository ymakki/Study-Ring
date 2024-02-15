class Public::FavoritesController < ApplicationController

  def create
    study = Study.find(params[:study_id])
    favorite = current_user.favorites.new(study_id: study.id)
    favorite.save
    redirect_to request.referer
  end

  def destroy
    study = Study.find(params[:study_id])
    favorite = current_user.favorites.find_by(study_id: study.id)
    favorite.destroy
    redirect_to request.referer
  end

end