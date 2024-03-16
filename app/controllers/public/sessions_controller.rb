# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :user_state, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # ゲストログイン
  def guest_sign_in
    user = User.guest
    sign_in user
    flash[:success] = "ゲストでログインしました"
    redirect_to user_path(user)
  end

  protected

  # 会員アクティブ確認
  def user_state
    user = User.find_by(email: params[:email])
    return if user.nil?
    return unless user.valid_password?(params[:password])
    if user.is_active
      sign_in(user)
    else
      flash[:danger] = "既に退会済みのアカウントです。新規会員登録が必要になります"
      redirect_to new_user_registration_path
    end
  end

  def after_sign_in_path_for(resource)
    flash[:success] = "ログインしました"
    user_path(current_user)
  end

  def after_sign_out_path_for(resource)
    flash[:success] = "ログアウトしました"
    new_user_session_path
  end

end
