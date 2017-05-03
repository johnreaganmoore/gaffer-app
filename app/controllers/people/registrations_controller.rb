class People::RegistrationsController < Devise::RegistrationsController
# before_action :configure_sign_up_params, if: :devise_controller?, only: [:create]
# before_action :configure_person_update_params, only: [:update]
  layout "app", only: [:edit]
  # GET /resource/sign_up
  def new
    super do |person|
      @plan = params[:plan]

      @token = params[:invitation_token]
      if params[:team] != nil
        @team = Team.friendly.find(params[:team])
        @team.player_avatars.each do |avatar|
          puts avatar
        end
      end
      if @token != nil
        @invite = Invite.find_by_token(@token)
        @team = @invite.team
      end
    end
  end

  # POST /resource

  def create
    super do |person|
      @token = params[:invitation_token]

      if params[:team] != nil
        @team = Team.friendly.find(params[:team])
      end

      if @token != nil
        #  team =  Invite.find_by_token(@token).team #find the user group attached to the invite
        #  person.teams.push(team) #add this user to the new user group as a member
        invitation = Invite.find_by_token(@token)

        invitation.recipient_id = person.id

        invitation.save

        person.invitation_token = invitation.token
        person.first_name = invitation.first_name
        person.last_name = invitation.last_name
        person.teams.push(invitation.team)
        person.save
        person.accept_invitation!
      else
        # do normal registration things #
        if @team != nil
          person.teams.push(@team)
        end
      end
      @person.save
    end



  end

  # GET /resource/edit
  def edit
    super do
      @team = current_person.teams.first
    end
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:invitation_token])
  # end



  # If you have extra params to permit, append them to the sanitizer.
  # def configure_person_update_params
  #   devise_parameter_sanitizer.permit(:person_update, keys: [:attribute])
  # end

  def after_update_path_for(person)
    account_path(person)
  end


  #TODO add some logic to the after sign_up path to check to see if they joined from an invite.
  # After they signup, have them edit/review personal details.
  # After they have edited/updated personal details then if they came from an invite take them to that team.
  def after_sign_up_path_for(person)
    # team_path(person.teams.first)
    # edit_person_registration_path(person)

    sign_in(person)
    onboarding_path(:create_profile, plan: params[:plan])
    # person.goggle
  end

  # The path used after sign up for inactive people.
  def after_inactive_sign_up_path_for(person)
    # team_path(person.teams.first)
    # edit_person_registration_path(person)

    sign_in(person)
    onboarding_path(:create_profile, plan: params[:plan])
  end

end
