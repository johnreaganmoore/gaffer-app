class People::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @person = Person.from_omniauth(request.env["omniauth.auth"])

    if @person.persisted?
      sign_in_and_redirect @person, :event => :authentication #this will throw if @person is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_person_registration_url
    end
  end

  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @person = Person.from_omniauth(request.env["omniauth.auth"])

    if @person.persisted?
      sign_in_and_redirect @person, :event => :authentication #this will throw if @person is not activated
      set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_person_registration_url
    end
  end

  def failure
    puts "Failure to auth via omniauth"
    redirect_to new_person_registration_url
  end

  def after_sign_in_path_for(person)
    if person.teams[0] != nil then
      team_path(person.teams[0])
    else
      onboarding_path(:create_team)
    end
    # request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

end
