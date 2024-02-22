class Notification < ApplicationRecord
  # モデルの中でxxx_pathメソッドを使用するために必要
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  # 通知の表示
  def message
    case notifiable_type
    when "Favorite"
      "<i class='fa-regular fa-thumbs-up'></i>　#{notifiable.user.name}さんがあなたの勉強記録にいいね！と言っています".html_safe
    when "Message"
      "<i class='fa-regular fa-envelope'></i>　#{notifiable.user.name}さんがあなたに返信しました".html_safe
    when "Relationship"
      "<i class='fa-regular fa-handshake'></i>　#{notifiable.user.name}さんがあなたをフォローしました".html_safe
    when "StudyComment"
      "<i class='fa-regular fa-comment'></i>　#{notifiable.user.name}さんがあなたの勉強記録にコメントしました".html_safe
    else
      "<i class='fa-solid fa-book-open'></i>　#{notifiable.user.name}さんがレビューを投稿しました".html_safe
    end
  end

  # 通知の遷移先
  def notifiable_path
    case notification.notifiable_type
    when "Favorite"
      user_path(notification.notifiable)
    when "Message"
      room_path(notification.notifiable)
    when "Relationship"
      user_path(notification.notifiable)
    when "StudyComment"
      study_record_path(notification.notifiable)
    else
      study_study_review_path(notification.notifiable)
    end
  end

end
