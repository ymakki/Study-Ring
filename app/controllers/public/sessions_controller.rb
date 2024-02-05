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

  # ゲストログイン機能
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to user_path(user), notice: "guestuserでログインしました。"
  end

  protected

  # 退会機能
  def user_state
    user = User.find_by(email: params[:user][:email])
    return if user.nil?
    return unless user.valid_password?(params[:user][:password])
    if user.is_active
      sign_in(user)
      redirect_to root_path
    else
      flash[:notice] = "既に退会済みのアカウントです。新規会員登録が必要になります。"
      redirect_to new_user_registration_path
    end
  end

  # ログイン後の遷移先
  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

end
