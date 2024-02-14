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
      member do
        get "record", to: "studies#record", as: :record
      end
      resources :study_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end

    # ユーザー
    resources :users, only: [:index, :show, :edit, :update] do
      member do
        get "unsubscribe", to: "users#unsubscribe", as: :unsubscribe
        patch "withdrawal", to: "users#withdrawal", as: :withdrawal
      end
    end

    # 検索
    get "search", to: "searches#search"
    get  "tagsearch", to: "tagsearches#search"

  end

  # 管理者側
  namespace :admin do
    root :to =>"users#index"

    # 教材
    resources :studies, only: [:index, :show, :edit, :update] do
      resources :study_comments, only: [:index, :update]
    end

    # ユーザー
    resources :users, only: [:index, :show, :edit, :update]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end