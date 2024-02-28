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
    resources :studies do
      get "copy", to: "studies#copy"
      resources :records, except: [:index] do
        resource :favorites, only: [:create, :destroy]
        resources :study_comments, only: [:create, :destroy]
      end
      resources :study_reviews, except: [:index] do
        resource :review_favorites, only: [:create, :destroy]
        resources :review_comments, only: [:create, :destroy]
      end
    end
    resources :records, only: [:index]

    # ユーザー
    resources :users, only: [:index, :show, :edit, :update] do
      resources :studies, only: [:index], module: "users"
      member do
        get "unsubscribe", to: "users#unsubscribe", as: :unsubscribe
        patch "withdrawal", to: "users#withdrawal", as: :withdrawal
        get "following", to: "relationships#following", as: :following
        get "followers", to: "relationships#followers", as: :followers
      end
      resource :relationships, only: [:create, :destroy]
      resources :tags, except: [:show]
    end

    # 検索
    get "search", to: "searches#search"
    get  "tagsearch", to: "tagsearches#search"

    # DM
    resources :messages, only: [:create]
    resources :rooms, only: [:index, :create, :show]

    # ソート
    get "sort", to: "studies#sort"

    # 通知
    resources :notifications
  end

  # 管理者側
  namespace :admin do
    root :to =>"users#index"

    # コメント
    resources :study_comments, only: [:index, :destroy]
    # ユーザー
    resources :users, only: [:index, :show, :edit, :update]
    # レビュー
    resources :study_reviews, only: [:index, :destroy]

  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end