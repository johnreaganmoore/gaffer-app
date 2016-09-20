class SeasonsController < ApplicationController
  before_action :authenticate_person!
  layout "app" #, only: [:index, :edit, :update, :destroy]
  # layout "team", only: [:show]

  before_action :set_season, only: [:show, :edit, :update, :destroy]

  # GET /teams
  # GET /teams.json
  def index
    @seasons = Season.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @season = Season.new
  end

  # GET /teams/1/edit
  def edit
    @team = current_person.teams[0]
  end

  # POST /teams
  # POST /teams.json
  def create

    @season = Season.new(season_params)
    @season.save

    respond_to do |format|
      if @season.save
        format.html { redirect_to @season, notice: 'Season was successfully created.' }
        format.json { render :show, status: :created, location: @season }
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
        format.html { redirect_to @season, notice: 'Season was successfully updated.' }
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
        :min_players
      )
    end

end
