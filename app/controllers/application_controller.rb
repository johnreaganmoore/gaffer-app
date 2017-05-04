class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_ability
    @current_ability ||= Ability.new(current_person)
  end

  def active_org
    @active_org ||= Org.find(session[:admin_org]["id"])
  end

  def set_layout
    if request.subdomain == "register" || request.subdomain == "subs" || request.subdomain == "collect"
      return "league_admin"
    elsif request.subdomain == "relate"
      return "relate"
    else
      return "app"
    end
  end

  def after_sign_in_path_for(person)

    if person.take_admin_org
      session[:admin_org] = person.take_admin_org
    end

    # If they don't have a name, take them to profile creation
    if person.first_name == nil then
      return onboarding_path(:create_profile, plan: params[:plan])
    end

    if request.subdomain == "register"
      return orgs_path
    end

    if request.subdomain == "collect"
      return orgs_path
    end

    if request.subdomain == "relate"
      # if person.first_name == nil then
      #   return onboarding_path(:create_profile, params[:plan])
      # end
      if self.active_org
        return contacts_path
      else
        return orgs_path
      end
    end

    if request.subdomain == "subs"
      return list_index_path
    end

    # If no subdomain, I will need to check conditions of teams/orgs.
    # See which they have, if neither route to account page and then allow them to choose product on the left.



    # If they already have a team, take them to their teams page.
    if person.teams.length > 0 then
      team_path(person.teams.first)
    # Otherwise take them to create team step.
    else
        onboarding_path(:create_team)
    end

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
        :password_confirmation,
        :date_of_birth,
        :street_address,
        :locality,
        :region,
        :postal_code

      ])
    end
  end

end
