Rails.application.routes.draw do

  # 顧客用
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # 管理者用
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }

  # ゲストログイン機能
  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  # 顧客側
  scope module: :public do
    root :to =>"homes#top"

    resources :studies, only: [:new, :index, :show, :edit, :create, :destroy, :update] do
      resources :study_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
    end

    resources :users, only: [:index, :show, :edit, :create, :destroy, :update]
  end

  # 管理者側
  namespace :admin do
    root :to =>"homes#top"

    resources :studies, only: [:index, :show, :edit, :update] do
      resources :study_comments, only: [:index, :update]
    end

    resources :tags, only: [:index, :create, :edit, :update]

    resources :users, only: [:index, :show, :edit, :update]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
