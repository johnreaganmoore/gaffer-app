Rails.application.routes.draw do
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

  # scope :people do
  resources :profiles
  get 'profiles/:id/leave', to: 'profiles#leave', as: :leave_team
  # end



  # Special new team page for registration
  get 'register/team', to: 'teams#new'

  get "/", to: 'marketing#home'
  root to: 'marketing#home'


end
