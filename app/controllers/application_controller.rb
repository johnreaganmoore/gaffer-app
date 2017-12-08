class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_ability
    @current_ability ||= Ability.new(current_person)
  end

  def active_org
    if session[:admin_org]
      @active_org ||= Org.find(session[:admin_org]["id"])
    else
      @active_org = Org.new
    end
  end

  def set_current_person_tasks
    @current_person_tasks = Reminder.where(assignee_id: current_person.id).where.not(status: "archived").order(:next_date)
  end

  def set_unassigned_tasks
    @unassigned_tasks = Reminder.where(contact_id: @active_org.contacts.ids).where.not(status: "archived").where(assignee_id: nil).order(:next_date)
  end

  def set_new_submissions
    @new_submissions = @active_org.submissions.where(status: "new").order('updated_at DESC')
  end

  def get_due_tasks
    @due_tasks = []

    @current_person_tasks.where(status: "incomplete").each do |task|
      if task.next_date <= Date.today
        @due_tasks << task
      end
    end

    @due_tasks
  end

  def set_layout
      return "relate"
  end

  def after_sign_in_path_for(person)

    if person.take_admin_org
      session[:admin_org] = person.take_admin_org
    end

    # If they don't have a name, take them to profile creation
    if person.first_name == nil then
      return onboarding_path(:create_profile, plan: params[:plan])
    end

    if self.active_org
      return contacts_path
    else
      return orgs_path
    end

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
