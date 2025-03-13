Rails.application.routes.draw do
  resources :posts
  resources :videos
  resources :news

  get 'feed', to: 'feed#index'
  get 'feed/:type', to: 'feed#index', as: 'filtered_feed'

  root 'feed#index'
end
