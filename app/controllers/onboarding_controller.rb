class OnboardingController < Wicked::WizardController
  before_action :authenticate_person!

  steps :create_profile, :create_team

  def show
    @person = current_person
    case step
    # when :accept_team_invitation
    #   @invite = Invite.find_by_token(@person.invitation_token)
    when :create_team
      skip_step if @person.teams.first != nil
      @team = Team.new
    end

    render_wizard
  end

  def update
    @person = current_person
    @person.update_attributes(person_params)
    render_wizard @person
  end


  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def person_params
    params.require(:person).permit(:first_name, :last_name, :avatar, :email, :phone)
  end

  def finish_wizard_path
    team_path(current_person.teams.first)
  end

end
