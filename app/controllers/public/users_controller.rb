class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :ensure_guest_user, only: [:edit, :withdrawal]

  def show
    @user = User.find(params[:id])
    @timelines = Timeline.where(user_id: @user.id).order(created_at: :desc)
    @tag_names = Tag.where(id: @user.tag_ids).pluck(:name).join('　')

    unless @user.id == current_user.id
      current_user.entries.includes(:room).each do |current_user_entry|
        @user.entries.includes(:room).each do |user_entry|
          if current_user_entry.room_id == user_entry.room_id
            @isRoom = true
            @roomId = current_user_entry.room_id
          end
        end
      end
      unless @isRoom
        @room = Room.new
        @entry = Entry.new
      end
    end

  end

  def index
    @users = User.all
    @users = @users.where.not(id: current_user.id) if current_user.present?
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "更新しました"
    else
      render "edit"
    end
  end

  # 退会機能
  def withdrawal
    @user = current_user
    @user.update(is_active: false)
    reset_session
    flash[:notice] = "退会処理を実行しました"
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
      redirect_to user_path(current_user) , notice: "ゲストユーザーに許可していない操作です。"
    end
  end

end