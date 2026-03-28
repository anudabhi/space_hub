Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  root "pages#home"

  # Static pages
  get "about",        to: "pages#about"
  get "how-it-works", to: "pages#how_it_works", as: :how_it_works
  get "privacy",      to: "pages#privacy"
  get "terms",        to: "pages#terms"
  get "become-a-host", to: "pages#become_host", as: :become_host_page

  # Become a host
  patch "users/become_host", to: "users/become_host#update", as: :become_host

  # Public host profiles
  resources :hosts, only: %i[show]

  # Notifications
  resources :notifications, only: %i[index] do
    collection { patch :mark_all_read }
    member     { patch :mark_read }
  end

  # Public listings
  resources :listings, only: %i[index show] do
    resources :bookings, only: %i[new create]
    resources :reviews, only: %i[create]
  end

  # AI listing description generator
  post "chat/message", to: "chat#message", as: :chat_message
  post "ai/generate_description", to: "ai#generate_description", as: :ai_generate_description
  post "ai/suggest_price",        to: "ai#suggest_price",        as: :ai_suggest_price

  # Payments
  post "payments/razorpay/create_order",  to: "payments#razorpay_create_order",  as: :razorpay_create_order
  post "payments/razorpay/verify",        to: "payments#razorpay_verify",        as: :razorpay_verify
  post "payments/stripe/create_session",  to: "payments#stripe_create_session",  as: :stripe_create_session
  get  "payments/stripe/success",         to: "payments#stripe_success",         as: :stripe_success
  get  "payments/stripe/cancel",          to: "payments#stripe_cancel",          as: :stripe_cancel
  post "webhooks/razorpay",               to: "webhooks#razorpay",               as: :razorpay_webhook
  post "webhooks/stripe",                 to: "webhooks#stripe",                 as: :stripe_webhook

  # Guest namespace
  namespace :guest do
    root "dashboard#index"
    resources :bookings, only: %i[index show] do
      member { patch :cancel }
    end
  end

  # Host namespace
  namespace :host do
    root "dashboard#index"
    patch "dashboard/confirm_booking", to: "dashboard#confirm_booking", as: :dashboard_confirm_booking
    resources :listings do
      resources :availabilities, only: %i[index create destroy]
    end
    resources :bookings, only: %i[index show] do
      member do
        patch :confirm
        patch :complete
      end
    end
    resources :gateway_configs, only: %i[index] do
      collection { post :upsert }
    end
    resources :payments, only: %i[index]
  end

  # Admin namespace
  namespace :admin do
    root "dashboard#index"
    resources :users
    resources :listings do
      member { patch :approve }
    end
    resources :bookings
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
