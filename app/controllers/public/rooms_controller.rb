class Public::RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_non_related, only: [:show]

  def index
    @rooms = current_user.rooms
  end

  def create
    # 1. Roomオブジェクトを作成する
    room = Room.create
    # 2. 現在のユーザーをルームにエントリーさせる
    entry = Entry.new(user_id: current_user.id, room_id: room.id)
    entry.save
    # 3. フォームから送信されたエントリー情報を使用して、エントリーを作成する
    entry_params = params.require(:entry).permit(:user_id)
    entry_params[:room_id] = room.id
    entry = Entry.new(entry_params)
    if entry.save
      redirect_to room_path(room)
    else
      flash[:danger] = "チャットルームの作成に失敗しました"
      redirect_to user_path(current_user)
    end
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages
      @entries = @room.entries
    else
      flash[:danger] = "チャットルームが見つかりませんでした"
      redirect_to user_path(current_user)
    end
  end

  private

  # 相互フォローか
  def reject_non_related
    room = Room.find(params[:id])
    user = room.entries.where.not(user_id: current_user.id).first.user
    unless (current_user.following?(user)) && (user.following?(current_user))
      redirect_to user_path(current_user)
    end
  end
end
