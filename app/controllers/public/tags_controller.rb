class Public::TagsController < ApplicationController

  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def index
    @tags = Tag.all
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = current_user.tags.new(tag_params)

    if @tag.save
      redirect_to user_tags_path, notice: "記録しました"
    else
      render "new"
    end
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
    if @tag.update(tag_params)
      redirect_to tags_path, notice: "更新しました"
    else
      render "index"
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    redirect_to tags_path
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
