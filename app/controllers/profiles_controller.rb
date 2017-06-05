class ProfilesController < ApplicationController
  before_action :authenticate_person!, :set_person
  before_action :active_org

  layout :set_layout

  def show
    @team = @person.teams.first
  end

  def leave
    @team = Team.friendly.find(params[:team])
    @person.leave_team(@team)

    redirect_to team_path(@team)
  end

  def edit
    @profile = Person.find(params[:id])
  end

  def account
    @profile = Person.find(params[:id])
    @plan = @profile.plan_id_from_stripe
    # @plan = "connect-team-yearly"
  end

  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to edit_profile_path(@person), notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: edit_profile_path(@person) }
        format.js {}
      else
        format.html { render :edit }
        format.json { render json: edit_profile_path(@person).errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    def person_params
      params.require(:person).permit(
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
      )
    end

end
