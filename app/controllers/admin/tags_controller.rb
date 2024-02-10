class Admin::TagsController < ApplicationController

  def index
    @tag = tag.new
    @tags = tag.all
  end

  def create
    @tag = tag.new(tag_params)
    @tag.save
    flash[:notice] = "新規作成に成功しました。"
    @tags = tag.all
  end

  def edit
    @tag = tag.find(params[:id])
  end

  def update
    @tag=tag.find(params[:id])
    @tag.update(tag_params)
    redirect_to admin_tags_path
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

end
