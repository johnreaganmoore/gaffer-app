class SeasonsController < ApplicationController
  before_action :authenticate_person!, except: [:show, :accept, :decline, :register]
  layout "app", except: [:show, :accept, :decline, :register, :new, :edit] #, only: [:index, :edit, :update, :destroy]
  layout "league_admin", only: [:new, :edit]

  before_action :set_season, except: [:index, :new, :create]
  before_action :active_org, except: [:index, :show]

  # GET /teams
  # GET /teams.json
  def index
    @seasons = Season.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  # GET /teams/1/edit
  def edit
  end

  def register
    if current_person
      @person = current_person
    else
      @person = Person.new
    end
  end

  # GET /teams/new
  def new
    @season = Season.new
  end

  # POST /teams
  # POST /teams.json
  def create
    @season = Season.create(season_params)
    respond_to do |format|
      if @season.save
        format.html { redirect_to season_path(@season), notice: 'Season was successfully created.' }
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

    if season_params[:team_seasons_attributes]
      # @team_season = TeamSeason.find(season_params[:team_seasons_attributes]['0'][:id])
      # @team = @team_season.team
    end


    respond_to do |format|
      if @season.update(season_params)
        format.html { redirect_to season_path(@season), notice: 'Season was successfully updated.' }
        format.json { render :show, status: :ok, location: @season }
        format.js {}
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
        :league_id,
        :league_name,
        :website,
        :location,
        :location_lat,
        :location_long,
        :start_date,
        :end_date,
        :cost,
        :total_games,
        :format,
        timeframe_ids: [],
        team_seasons_attributes: [
          :id,
          :min_players,
          :max_players,
        ]
      )
    end

end
