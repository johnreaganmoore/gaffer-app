class OnboardingController < Wicked::WizardController
  before_action :authenticate_person!
  # layout "app"

  steps :create_profile, :season, :season_cost, :season_payment

  def show
    @person = current_person
    # @team_season = TeamSeason.new  # change this to create an actual season???
    case step
    # when :accept_team_invitation
    #   @invite = Invite.find_by_token(@person.invitation_token)
    # when :create_team
    #   skip_step if @person.teams.first != nil
    #   @team = Team.new
    #   @team.seasons.build
    when :season
      if params[:team] != nil
        @team = Team.find(params[:team])
      else
        @team = Team.create_random
      end

      if params[:season] != nil
        @season = Season.find(params[:season])
      else
        @season = Season.create
      end
      @team_season = TeamSeason.create(team_id: @team.id, season_id: @season.id)
      @team_season.add_creator(current_person)
      @team_season.set_treasurer(current_person)

    when :season_cost
      @team_season = TeamSeason.find(params[:ts])

    when :season_payment
      @team_season = TeamSeason.find(params[:ts])
      @team = @team_season.team
      @person = current_person
      @payment = @person.payment_composition(@team_season.new_player_cost, 0.05, 0)
    end


    render_wizard
  end

  def update
    @person = current_person
    case step
    when :create_profile
      @person.update_attributes(person_params)
      render_wizard @person
    when :season
      @team_season = TeamSeason.find(params[:ts])
      @season = @team_season.season
      @season.update_attributes(season_params)
      redirect_to wizard_path(:season_cost, ts: @team_season.id)
      # render_wizard(@season, ts: @team_season.id)
    when :season_cost
      @team_season = TeamSeason.find(params[:ts])
      @team_season.update_attributes(team_season_params)
      redirect_to wizard_path(:season_payment, ts: @team_season.id)
    when :season_payment
      render_wizard

    end
  end


  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def person_params
    params.require(:person).permit(
      :first_name,
      :last_name,
      :avatar,
      :email,
      :phone,
      :date_of_birth,
      :street_address,
      :locality,
      :region,
      :postal_code
    )
  end

  def season_params
    params.require(:season).permit(:format, :location, timeframe_ids: [])
  end

  def team_season_params
    params.require(:team_season).permit(:cost, :min_players, :max_players)
  end

  def finish_wizard_path
    team_path(current_person.teams.first)
  end

end
