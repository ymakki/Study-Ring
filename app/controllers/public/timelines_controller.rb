class Public::TimelinesController < ApplicationController

  def index
    # フォローしているユーザーのID一覧を取得
    followed_user_ids = current_user.following.pluck(:id)
    # フォローしているユーザーと自身のレコードとレビューを取得
    @timelines = Timeline.where(user_id: [current_user.id] + followed_user_ids).order(created_at: :desc)
  end

end
