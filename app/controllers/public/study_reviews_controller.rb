class Public::StudyReviewsController < ApplicationController

  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @study_review = StudyReview.new
    @study = Study.find(params[:study_id])
  end

  def create
    # 取得した教材にレビューを保存
    @study = Study.find(params[:study_id])
    @study_review = current_user.study_reviews.new(study_reviews_params)
    @study_review.study_id = @study.id

    if @study_review.save
      # レビューをタイムラインモデルに保存
      Timeline.create(user_id: current_user.id, study_review_id: @study_review.id, created_at: @study_review.created_at)
      redirect_to study_path(@study), notice: "レビューを保存しました"
    else
      render :new
    end
  end

  def show
    @study_review = StudyReview.find(params[:id])
    @study = @study_review.study
    @user = @study_review.user
    @review_comment = @study_review.review_comments.build
  end

  def edit
    @study_review = StudyReview.find(params[:id])
    @study = @study_review.study
  end

  def update
    @study_review = StudyReview.find(params[:id])
    if @study_review.update(study_reviews_params)
      redirect_to study_study_review_path(@study_review), notice: "更新しました"
    else
      @study = @study_review.study
      @user = @study.user
      render "show"
    end
  end

  def destroy
    @study_review = StudyReview.find(params[:id])
    @study_review.destroy
    redirect_to timelines_path
  end

  private

  def study_reviews_params
    params.require(:study_review).permit(:user_id, :study_id, :title, :body)
  end

  def ensure_correct_user
    study_review = StudyReview.find(params[:id])
    unless study_review.user == current_user
      redirect_to new_study_study_review_path
    end
  end

end
