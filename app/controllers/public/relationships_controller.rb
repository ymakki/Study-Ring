class Public::RelationshipsController < ApplicationController

  before_action :authenticate_user!

  # フォロー追加機能
  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)
  end

  # フォロー削除機能
  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
  end

  # フォロワー一覧表示
  def followers
    @user = User.find(params[:id])
    @users = @user.followers
  end

  # フォロー一覧表示
  def following
    @user = User.find(params[:id])
    @users = @user.following
  end

  private

  def relationship_params
    params.require(:relationship).permit(:follower_id, :followed_id)
  end

end
