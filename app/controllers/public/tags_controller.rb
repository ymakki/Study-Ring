class Public::TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @tags = Tag.where(user_id: current_user.id)
  end

  def new
    @tag = Tag.new
    @user = current_user
  end

  def create
    @tag = Tag.new(tag_params)
    @tag.user_id = current_user.id

    if @tag.save
      flash[:success] = "タグを保存しました"
      redirect_to user_tags_path
    else
      @user = current_user
      render "new"
    end
  end

  def edit
    @tag = Tag.find(params[:id])
    @user = @tag.user
  end

  def update
    @tag = Tag.find(params[:id])
    if @tag.update(tag_params)
      flash[:success] = "更新しました"
      redirect_to user_tags_path
    else
      @user = @tag.user
      render "edit"
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    redirect_to user_tags_path
  end

  private

  def tag_params
    params.require(:tag).permit(:user_id, :study_id, :name)
  end

  def ensure_correct_user
    tag = Tag.find(params[:id])
    unless tag.user == current_user
      redirect_to studies_path
    end
  end
end
