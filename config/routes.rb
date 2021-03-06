Rails.application.routes.draw do

  #api
  namespace :api do
    namespace :v1 do
      resources :contacts, only: [:index, :create, :show, :update]
      resources :contact_properties, only: [:index, :create, :show, :update]
      resources :submissions, only: [:index, :create, :show, :update]
      resources :reminders, only: [:index, :create, :show, :update]

      post 'hooks', to: 'hooks#subscribe', as: :hook_subscribe
      delete 'hooks', to: 'hooks#unsubscribe', as: :hook_unsubscribe

    end
  end

  resources :email_templates
  resources :contact_properties
  resources :reminders
  resources :notes
  get 'contacts/batch', to: 'contacts#batch', as: :contacts_batch
  post 'contacts/batch', to: 'contacts#batch_create', as: :contacts_batch_create
  get 'contacts/new_email', to: 'contacts#new_email', as: :contact_new_email
  get 'contacts/draft_list_email', to: 'contacts#draft_list_email', as: :draft_list_email
  post 'contacts/new_email_with_list', to: 'contacts#new_email_with_list', as: :post_contact_new_email
  post 'contact_email', to: 'contacts#send_email', as: :contact_email
  post 'filter_contacts', to: 'contacts#filter', as: :filter_contacts

  resources :submissions
  # get 'submissions', to: 'submissions#index', as: :submissions

  resources :contacts

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

  resources :invites
  get 'invites/:id/resend', to: 'invites#resend', as: :resend_invite

  resources :profiles
  get 'profiles/:id/leave', to: 'profiles#leave', as: :leave_team
  get 'profiles/:id/account', to: 'profiles#account', as: :account
  post 'profiles/:id/toggle', to: 'profiles#toggle', as: :toggle


  get 'admins/new', to: 'admins#new', as: :new_admin
  post 'admins', to: 'admins#create', as: :create_admin

  resources :orgs
  # resources :orgs, :path => ''
  # # resources :orgs, :path => '', :only => [] do
  # #   resources :projects, :path => '', :except => [:index]
  # # end


  resources :transactions, only: [:new, :create]

  post 'connect_subscribe', to: 'transactions#connect_subscribe', as: :connect_payment
  post 'update_subscription', to: 'transactions#update_subscription', as: :update_subscription

  get 'inbox', to: 'inbox#all', as: :inbox


  post "/webhooks", to: 'webhooks#recieve'

  get '/onboarding', to: 'relate_onboarding#profile'
  put '/onboarding', to: 'relate_onboarding#update_profile'

  resources :onboarding


  get '/tos', to: 'marketing#tos'

  get '/', to: 'marketing#relate', as: :home
  get "/", to: 'marketing#relate', as: :onside_home
  root to: 'marketing#relate'


end
