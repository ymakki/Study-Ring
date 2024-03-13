class Public::TimelinesController < ApplicationController
  before_action :authenticate_user!

  def index
    # フォローしているユーザーのID一覧を配列で取得
    followed_user_ids = current_user.following.pluck(:id)
    # 自身のIDを含む配列を作成
    user_ids_to_search = [current_user.id] + followed_user_ids
    # タイムラインを取得
    @timelines = Timeline.where(user_id: user_ids_to_search).order(created_at: :desc)
  end

  private

  def timelines_params
    params.require(:timeline).permit(:user_id, :record_id, :study_review_id)
  end
end
