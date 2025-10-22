Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "/my_lists", to: "pages#my_lists"

  resources :lists do
    resources :bookmarks, only: [:new, :create]
  end
  resources :bookmarks, only: :destroy

  resources :chats, only: [:show] do
    resources :messages, only: [:new, :create]
  end

end
