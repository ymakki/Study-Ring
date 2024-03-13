class Public::MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    if Entry.where(user_id: current_user.id, room_id: params[:message][:room_id]).present?
      @message = Message.new(message_params)
      @message.user_id = current_user.id
      @message.save
    end
  end

  private

  def message_params
    params.require(:message).permit(:user_id, :room_id, :content)
  end
end