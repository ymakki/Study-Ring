class Public::StudyReviewsController < ApplicationController

  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @review = StudyReview.new
    @study = Study.find(params[:study_id])
  end

  def create
    # 取得した教材にレビューを保存
    @study = Study.find(params[:study_id])
    @review = current_user.study_reviews.new(study_reviews_params)
    @review.study_id = @study.id

    if @review.save
      # レビューをタイムラインモデルに保存
      # reviews = StudyReview.where(user_id: current_user.id)
      # reviews.each do |review|
        Timeline.create(user_id: current_user.id, study_review_id: @review.id, created_at: @review.created_at)
      # end
      redirect_to study_path(@study), notice: "レビューを保存しました"
    else
      redirect_to new_study_study_review_path, notice: "保存に失敗しました"
    end
  end

  def show
    @review = StudyReview.find(params[:id])
    @study = @review.study
    @user = @review.user
    @review_comment = @review.review_comments.build
  end

  def edit
    @review = StudyReview.find(params[:id])
    @study = @review.study
  end

  def update
    @review = StudyReview.find(params[:id])
    if @review.update(study_reviews_params)
      redirect_to study_study_review_path(@review), notice: "更新しました"
    else
      @study = @review.study
      @user = @study.user
      render "show"
    end
  end

  def destroy
    @review = StudyReview.find(params[:id])
    @review.destroy
    redirect_to records_path
  end

  private

  def study_reviews_params
    params.require(:study_review).permit(:user_id, :study_id, :title, :body)
  end

  def ensure_correct_user
    review = StudyReview.find(params[:id])
    unless review.user == current_user
      redirect_to new_study_study_review_path
    end
  end

end
