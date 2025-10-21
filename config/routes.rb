Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home" #check

  resources :lists do
    resources :bookmarks, only: [:new, :create]
  end
  resources :bookmarks, only: :destroy
end
