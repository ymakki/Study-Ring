class Public::RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_non_related, only: [:show]

  def index
    @rooms = current_user.rooms
  end

  def create
    @room = Room.create
    Entry.create(room_id: @room.id, user_id: current_user.id)
    Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id))
    redirect_to room_path(@room)
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @entries = @room.entries
    else
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
