class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :ensure_guest_user, only: [:edit, :withdrawal]

  def show
    @user = User.find(params[:id])
    # タイムライン
    @timelines = Timeline.where(user_id: @user.id).order(created_at: :desc)
    # タグ
    tag_names_query = Tag.where(id: @user.tag_ids).pluck(:name)
    @tag_names = tag_names_query.join('　')
    # メッセージ
    unless @user.id == current_user.id
      shared_room_info = Entry.shared_room_info(current_user, @user)
      @isRoom = shared_room_info[:is_room]
      @roomId = shared_room_info[:room_id]

      unless @isRoom
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def index
    @users = User.all
    @users = @users.where.not(id: current_user.id)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "更新しました"
      redirect_to user_path(@user)
    else
      render "edit"
    end
  end

  # 退会機能
  def withdrawal
    @user = current_user
    @user.update(is_active: false)
    reset_session
    flash[:danger] = "退会しました"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :introduction,
      :birthday,
      :follow_request,
      :sex,
      :residence,
      :profile_image,
      :is_active,
      tag_ids:[],
    )
  end

  # ログインしているか
  def ensure_correct_user
    user = User.find(params[:id])
    unless user == current_user
      redirect_to user_path(current_user)
    end
  end

  # ゲストユーザーか
  def ensure_guest_user
    user = User.find(params[:id])
    if user.guest_user?
      flash[:danger] = "ゲストユーザーに許可していない操作です"
      redirect_to user_path(current_user)
    end
  end
end