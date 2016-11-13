class TeamSeasonsController < ApplicationController
  before_action :authenticate_person!, except: [:show, :accept, :decline, :confirm]
  layout "app", except: [:show, :accept, :decline, :confirm] #, only: [:index, :edit, :update, :destroy]
  # layout "team", only: [:show]

  before_action :set_season, except: [:index, :new, :create]

  # GET /teams
  # GET /teams.json
  def index
    @team_seasons = TeamSeason.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @team = @team_season.team
  end

  # GET /teams/1/edit
  def edit
    @team = @team_season.team
  end

  def preview
    @team = @team_season.team
  end

  def confirm
    @team = @team_season.team
    @pending_invitations = []
    @team.invites.each do |invite|
      unless @team.people.include?(invite.recipient) || invite.created_at != invite.updated_at
        @pending_invitations.push(invite)
      end
    end
  end

  def accept
    @team = @team_season.team
    @client_token = generate_client_token

    # If the person is logged in when on the accept page great!
    # if not we need to create a new person,
    # and if the email they use to create the new person is unique, we will save as a new record
    if current_person
      @person = current_person
    else
      @person = Person.new
    end
  end

  def decline
    @invite = Invite.new
    @team = @team_season.team
  end

  def price
    @team = @team_season.team
  end


  # GET /teams/new
  def new
    if params[:season] != nil
      @season = Season.find(params[:season])
    else
      @season =  Season.create!
    end
    if params[:team] != nil
      @team = Team.find(params[:team])
    else
      @team = Team.new
    end

    puts @season.inspect
    @team_season = TeamSeason.create(team_id: @team.id, season_id: @season.id)
  end

  # POST /teams
  # POST /teams.json
  def create

    # When coming from the onbaording flow this is how a season is created.
    @season = Season.create(season_params)

    @team_season = TeamSeason.new
    @team_season.season = @season
    @team_season.save

    @team_season.add_creator(current_person)
    @team_season.set_treasurer(current_person)


    respond_to do |format|
      if @team_season.save
        format.html { redirect_to preview_season_path(@team_season), notice: 'Season was successfully created.' }
        format.json { render :season_preview, status: :created, location: @team_season }
      else
        format.html { render :new }
        format.json { render json: @team_season.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    @team = @team_season.team

    respond_to do |format|
      if @team_season.update(team_season_params)
        format.html { redirect_to preview_season_path(@team_season), notice: 'Season was successfully updated.' }
        format.json { render :show, status: :ok, location: @team_season }
        format.js {}
      else
        format.html { render :edit }
        format.json { render json: @team_season.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team_season.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Season was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_season
      @team_season = TeamSeason.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_season_params
      params.permit(
        :id,
        :team_id,
        :min_players,
        :max_players,
        :status,
        timeframe_ids: [],
        person_attributes: [
          :date_of_birth,
          :street_address,
          :locality,
          :region,
          :postal_code
        ],
        season_attributes: [
          :league_name,
          :website,
          :location,
          :start_date,
          :end_date,
          :cost,
          :total_games,
          :format,
          :sport
        ]
      )
    end

    def season_params
      params.require(:season).permit(
        :location,
        :format,
        timeframe_ids: []
      )
    end

    def generate_client_token

      # puts "token below?"
      # puts current_person.has_payment_info?
      # puts "token above?"

      if current_person and current_person.has_payment_info?
        Braintree::ClientToken.generate(customer_id: current_person.braintree_customer_id)
      else
        Braintree::ClientToken.generate
      end
    end

end
