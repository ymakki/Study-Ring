class Room < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy

  # 引数としてuserを受け取り、そのユーザーとDMしたユーザーの情報を取得
  def other_user(user)
    entries.where.not(user_id: user.id).first.user
  end

end
