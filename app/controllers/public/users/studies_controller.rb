class Public::Users::StudiesController < ApplicationController

  before_action :authenticate_user!

  def index
    @user = User.find(params[:user_id])
    @studies = @user.studies
  end

  private

  def study_params
    params.require(:study).permit(:user_id, :title, :body, :status, :image, tag_ids: [])
  end

end
