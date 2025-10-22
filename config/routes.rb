Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :lists, only: [:index, :show]  do
    resources :bookmarks, only: [:new, :create, :destroy]
  end

  resources :chats, only: [:show] do
    resources :messages, only: [:new, :create]
  end

end
