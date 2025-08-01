Rails.application.routes.draw do
  # Scope để hỗ trợ đa ngôn ngữ qua URL: /en, /vi
  scope "(:locale)", locale: /en|vi/ do

    # Static pages
    get "about",   to: "static_pages#about"
    get "help",    to: "static_pages#help"
    get "contact", to: "static_pages#contact"

    # Root page
    root "static_pages#home"

    get "/signup", to: "users#new"
    post "/signup", to: "users#create"

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    # Resourceful routes
    resources :microposts, only: %i(create destroy)
    resources :account_activations, only: :edit
    resources :password_resets, only: %i(new create edit update)
    resources :relationships, only: %i(create destroy)
    resources :users do
      member do
        get :following, :followers
      end
    end
  end
end
