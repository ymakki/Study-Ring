Rails.application.routes.draw do

  # 顧客用
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  # 管理者用
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  # ゲストログイン
  devise_scope :user do
    post "users/guest_sign_in", to: "public/sessions#guest_sign_in"
  end

  # 顧客側
  scope module: :public do
    root :to =>"homes#top"

    # 教材
    resources :studies, only: [:new, :index, :show, :edit, :create, :destroy, :update] do
      resources :records, only: [:new, :edit, :show, :create, :update, :destroy] do
        resource :favorites, only: [:create, :destroy]
        resources :study_comments, only: [:create, :destroy]
      end
      resources :study_reviews, only: [:new, :show, :edit, :create, :destroy, :update]
    end
    resources :records, only: [:index]

    # ユーザー
    resources :users, only: [:index, :show, :edit, :update] do
      member do
        get "unsubscribe", to: "users#unsubscribe", as: :unsubscribe
        patch "withdrawal", to: "users#withdrawal", as: :withdrawal
        get "following", to: "relationships#following", as: :following
        get "followers", to: "relationships#followers", as: :followers
      end
      resource :relationships, only: [:create, :destroy]
    end

    # 検索
    get "search", to: "searches#search"
    get  "tagsearch", to: "tagsearches#search"

    # DM
    resources :messages, only: [:create]
    resources :rooms, only: [:index, :create, :show]

  end

  # 管理者側
  namespace :admin do
    root :to =>"users#index"

    # コメント
    resources :study_comments, only: [:index, :show, :destroy]
    # ユーザー
    resources :users, only: [:index, :show, :edit, :update]
    # レビュー
    resources :study_reviews, only: [:index, :show, :destroy]

  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end