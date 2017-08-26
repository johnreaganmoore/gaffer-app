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


  get 'philosophy', to: 'training#philosophy', as: :philosophy
  get 'coaches', to: 'training#coaches', as: :coaches
  get 'contact_onside', to: 'training#contact', as: :contact_onside
  get 'small_sided', to: 'training#small_sided', as: :small_sided
  get 'personal_training', to: 'training#personal_training', as: :personal_training
  get 'resources', to: 'training#resources', as: :resources
  get 'clinics', to: 'training#clinics', as: :clinics


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

  # scope :people do
  resources :profiles
  get 'profiles/:id/leave', to: 'profiles#leave', as: :leave_team
  get 'profiles/:id/account', to: 'profiles#account', as: :account
  post 'profiles/:id/toggle', to: 'profiles#toggle', as: :toggle

  # end
  get 'players/new', to: 'players#new', as: :new_player
  post 'players', to: 'players#create', as: :create_player

  get 'admins/new', to: 'admins#new', as: :new_admin
  post 'admins', to: 'admins#create', as: :create_admin

  get 'players/batch', to: 'players#batch', as: :players_batch
  post 'players/batch', to: 'players#batch_create', as: :players_batch_create


  resources :leads, only: [:new, :create]
  resources :orgs
  resources :leagues
  resources :seasons
  get 'seasons/:id/register', to: 'seasons#register', as: :season_register


  resources :team_seasons

  get 'team_seasons/:id/confirm_team', to: 'team_seasons#confirm_team', as: :team_season_confirm_team
  get 'team_seasons/:id/confirm', to: 'team_seasons#confirm', as: :confirm_team_season
  get 'team_seasons/:id/preview', to: 'team_seasons#preview', as: :preview_season
  get 'team_seasons/:id/accept', to: 'team_seasons#accept', as: :accept_season
  get 'team_seasons/:id/decline', to: 'team_seasons#decline', as: :decline_season
  get 'team_seasons/:id/price', to: 'team_seasons#price', as: :season_price
  get 'team_seasons/:id/disburse', to: 'team_seasons#disburse', as: :disburse
  get 'team_seasons/:id/dist_surplus', to: 'team_seasons#distribute_surplus', as: :dist_surplus
  get 'team_seasons/:id/cashed_out', to: 'team_seasons#cashed_out', as: :cashed_out

  resources :fees
  get 'fees/:id/confirm', to: 'fees#confirm', as: :confirm_fee

  resources :player_fees
  get 'player_fees/:id/confirm', to: 'player_fees#confirm', as: :confirm_pay_fee

  resources :transactions, only: [:new, :create]

  post 'kickoff', to: 'transactions#kickoff', as: :kickoff
  post 'player_purchase', to: 'transactions#player_purchase', as: :player_purchase
  post 'player_fee_payment', to: 'transactions#player_fee_payment', as: :player_fee_payment
  post 'captain_signup', to: 'transactions#captain_signup', as: :captain_signup

  post 'connect_subscribe', to: 'transactions#connect_subscribe', as: :connect_payment
  post 'update_subscription', to: 'transactions#update_subscription', as: :update_subscription

  resources :locations, except: [:update, :edit, :destroy]

  # Special new team page for registration
  get 'register/team', to: 'teams#new'


  post "/webhooks", to: 'webhooks#recieve'


  get '/', to: 'marketing#harrisburg', constraints: { subdomain: 'harrisburg' }
  get '/', to: 'marketing#connect', constraints: { subdomain: 'connect' }, as: :connect_home
  get '/', to: 'marketing#relate', constraints: { subdomain: 'relate' }, as: :relate_home
  get '/', to: 'marketing#register', constraints: { subdomain: 'register' }, as: :register_home
  get '/', to: 'marketing#tryout', constraints: { subdomain: 'tryout' }, as: :tryout_home
  get '/', to: 'marketing#collect', constraints: { subdomain: 'collect' }, as: :collect_home
  get '/', to: 'marketing#training', constraints: { subdomain: 'training' }, as: :training_home

  get '/onboarding', to: 'register_onboarding#profile', constraints: { subdomain: 'register' }
  put '/onboarding', to: 'register_onboarding#update_profile', constraints: { subdomain: 'register' }

  get '/onboarding', to: 'subs_onboarding#profile', constraints: { subdomain: 'subs' }
  put '/onboarding', to: 'subs_onboarding#update_profile', constraints: { subdomain: 'subs' }

  get '/onboarding', to: 'collect_onboarding#profile', constraints: { subdomain: 'collect' }
  put '/onboarding', to: 'collect_onboarding#update_profile', constraints: { subdomain: 'collect' }

  get '/onboarding', to: 'relate_onboarding#profile', constraints: { subdomain: 'relate' }
  put '/onboarding', to: 'relate_onboarding#update_profile', constraints: { subdomain: 'relate' }

  resources :onboarding
  resources :season_creator

  get '/find', to: 'subs#find', constraints: {subdomain: 'subs'}
  get '/select', to: 'subs#select', constraints: {subdomain: 'subs'}
  post '/select', to: 'subs#select', constraints: {subdomain: 'subs'}
  get '/email', to: 'subs#email', constraints: {subdomain: 'subs'}
  post '/email', to: 'subs#email', constraints: {subdomain: 'subs'}

  get '/lists', to: 'sub_lists#index', as: :list_index
  get '/lists/new', to: 'sub_lists#new', as: :new_list
  post '/lists/new', to: 'sub_lists#create'
  post '/lists', to: 'sub_lists#create'
  post '/sub_lists', to: 'sub_lists#create'

  get '/lists/:id/edit', to: 'sub_lists#edit', as: :edit_list


  get '/sub_list_memberships/batch', to: 'sub_list_memberships#batch', as: :list_member_batch
  post '/sub_list_memberships/batch', to: 'sub_list_memberships#batch_create', as: :list_member_batch_create
  resources :sub_list_memberships


  # #TODO
  #  Create a list model with a name and an airtable id.
  #  Allow creation of new lists.
  #  Create a list index that shows each list as a card with the actions of "Contact", and "Edit"
  #   - "contact" goes to the find action with the list id as a param, so we can use the lists airtable id to get the right player DB.
  #   - "Edit" is a link to the appropriate airtable
  #     step 2, create an interface for adding and removing players from the list but use airtable still for db
  #     step 3 , use our own db





  get '/find', to: 'subs#find', as: :find_subs
  get '/select', to: 'subs#select'
  post '/select', to: 'subs#select'
  post '/email', to: 'subs#email'


  get '/', to: 'marketing#subs', constraints: { subdomain: 'subs' }
  get '/', to: 'marketing#subs', constraints: { subdomain: 'subfinder' }
  get '/subs', to: 'marketing#subs', constraints: { subdomain: 'harrisburg' }
  get '/subs', to: 'marketing#subs'

  get '/tos', to: 'marketing#tos'

  get '/', to: 'marketing#logos', constraints: { subdomain: 'logos' }
  get '/logos', to: 'marketing#logos'

  get "/", to: 'training#resources', as: :onside_home
  root to: 'training#resources'
  # get "/", to: 'marketing#coming_soon'
  # root to: 'marketing#coming_soon'



end
