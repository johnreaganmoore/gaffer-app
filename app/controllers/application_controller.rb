class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_ability
    @current_ability ||= Ability.new(current_person)
  end


  def after_sign_in_path_for(person)
    team_path(person.teams.first)

    # request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  def after_sign_up_path_for(resource)
    # 'register/person'
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  # The path used after sign up for inactive people.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  def after_inactive_sign_up_path_for(resource)
    # 'register/person'
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |person_params|
      person_params.permit([
        :invitation_token,
        :team,
        :email,
        :avatar,
        :first_name,
        :last_name,
        :password,
        :password_confirmation
      ])
    end
  end

end
