class LeaguesController < ApplicationController
  # layout "league_admin", except: [:show]
  before_action :authenticate_person!, except: [:index, :show]
  before_action :set_league, except: [:index, :new, :create]
  before_action :active_org, except: [:index, :show]
  layout :set_layout

  def index
    if current_person and session[:admin_org]
      @active_org ||= Org.find(session[:admin_org]["id"])
      @leagues = @active_org.leagues
    else
      @leagues = League.order('created_at DESC')
    end
  end

  def new
    @league = League.new
  end

  def create
    @league = League.new(league_params)
    @league.org_id = session[:admin_org]["id"]

    if @league.save
      flash[:success] = "League added!"
      redirect_to edit_league_path(@league)
    else
      render 'new'
    end
  end

  def update
    respond_to do |format|
      if @league.update(league_params)
        format.html { redirect_to edit_league_path(@league), notice: 'League was successfully updated.' }
        format.json { render :edit, status: :ok, location: @league }
      else
        format.html { render :edit }
        format.json { render json: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  private

  def league_params
    params.require(:league).permit(:name, :external_link, :players_per_team, :minutes_per_game, :facility_type)
  end

  def set_league
    @league = League.find(params[:id])
  end
end
