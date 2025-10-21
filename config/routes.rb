Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :lists, only: [:index, :show]  do
    resources :bookmarks, only: [:new, :create, :destroy]
  end
end
