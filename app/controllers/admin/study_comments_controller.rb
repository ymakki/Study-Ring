class Admin::StudyCommentsController < ApplicationController

  before_action :authenticate_admin!

  def index
    @comments = StudyComment.all
  end

  def show
    @comment = StudyComment.includes(:user).find(params[:id])
    @user = @comment.user
    @comments = @user.study_comments
  end

  def destroy
    @comment = StudyComment.find_by(id: params[:id])
    @comment.destroy
    redirect_to admin_study_comments_path
  end

  private

  def study_comment_params
    params.require(:study_comment).permit(:comment)
  end

end
