class Public::NotificationsController < ApplicationController

  before_action :authenticate_user!

  def index
    @unread_notifications = current_user.notifications.where(read: false).order(created_at: :desc)
  end

  # 既読更新
  def update
    notification = current_user.notifications.find(params[:id])
    notification.update(read: true)
    redirect_to notification.notifiable_path
  end

  private

  def notification_params
    params.require(:notification).permit(:read)
  end

end
