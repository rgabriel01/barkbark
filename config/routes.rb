Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users

  resources :dogs, only: %i[show index new create edit update] do
    post '/post_like', action: :post_like, as: :post_like, on: :member
  end

  root to: "dogs#index"
end
