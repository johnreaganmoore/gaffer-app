Rails.application.routes.draw do
  get 'transactions/new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :people,
    path: '',
    path_names:
    {
      sign_up: 'register',
    },
    controllers: {
      registrations: 'people/registrations',
      omniauth_callbacks: "people/omniauth_callbacks"
    }

  # devise_scope :person do
  #   delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_person_session
  # end

  resources :teams
  get 'teams/:id/sweep', to: 'teams#sweep_invites', as: :sweep_invites
  # resources :people
  resources :invites
  get 'invites/:id/resend', to: 'invites#resend', as: :resend_invite

  resources :onboarding
  resources :season_creator

  # scope :people do
  resources :profiles
  get 'profiles/:id/leave', to: 'profiles#leave', as: :leave_team
  get 'profiles/:id/account', to: 'profiles#account', as: :account
  # end

  resources :seasons
  get 'seasons/:id/preview', to: 'seasons#preview', as: :preview_season
  get 'seasons/:id/accept', to: 'seasons#accept', as: :accept_season
  get 'seasons/:id/decline', to: 'seasons#decline', as: :decline_season
  get 'seasons/:id/price', to: 'seasons#price', as: :season_price

  resources :transactions, only: [:new, :create]

  resources :locations, except: [:update, :edit, :destroy]

  # Special new team page for registration
  get 'register/team', to: 'teams#new'


  post "/webhooks", to: 'webhooks#recieve'

  get "/", to: 'marketing#home'
  root to: 'marketing#home'


end
