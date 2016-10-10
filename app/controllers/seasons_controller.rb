class SeasonsController < ApplicationController
  before_action :authenticate_person!, except: [:show, :accept, :decline]
  layout "app", except: [:show, :accept, :decline] #, only: [:index, :edit, :update, :destroy]
  # layout "team", only: [:show]

  before_action :set_season, except: [:index, :new, :create]

  # GET /teams
  # GET /teams.json
  def index
    @seasons = Season.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @team = @season.team
  end

  # GET /teams/1/edit
  def edit
    @team = @season.team
  end

  def preview
    @team = @season.team
  end

  def accept
    @team = @season.team
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
    @team = @season.team
  end

  def price
    @team = @season.team
  end


  # GET /teams/new
  def new
    @season = Season.new
    @team = Team.find(params[:team])
  end

  # POST /teams
  # POST /teams.json
  def create

    @season = Season.create(season_params)
    @season.add_creator(current_person)
    @season.set_treasurer(current_person)

    respond_to do |format|
      if @season.save
        format.html { redirect_to preview_season_path(@season), notice: 'Season was successfully created.' }
        format.json { render :season_preview, status: :created, location: @season }
      else
        format.html { render :new }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @season.update(season_params)
        format.html { redirect_to preview_season_path(@season), notice: 'Season was successfully updated.' }
        format.json { render :show, status: :ok, location: @season }
      else
        format.html { render :edit }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @season.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Season was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_season
      @season = Season.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def season_params
      params.require(:season).permit(
        :team_id,
        :league_name,
        :website,
        :location,
        :start_date,
        :end_date,
        :cost,
        :total_games,
        :format,
        :min_players,
        :sport,
        timeframe_ids: [],
        person_attributes: [
          :date_of_birth,
          :street_address,
          :locality,
          :region,
          :postal_code
        ]
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
