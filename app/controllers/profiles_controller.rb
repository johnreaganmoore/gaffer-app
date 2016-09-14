class ProfilesController < ApplicationController

  layout "app"

  before_action :set_person

  def show
    @team = @person.teams.first
  end

  def leave
    @team = Team.friendly.find(params[:team])
    @person.leave_team(@team)

    redirect_to team_path(@team)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

end
