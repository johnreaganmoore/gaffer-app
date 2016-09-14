class TeamsController < ApplicationController
  layout "app" #, only: [:index, :edit, :update, :destroy]
  # layout "team", only: [:show]

  before_action :set_team, only: [:show, :edit, :update, :destroy, :sweep_invites]

  # GET /teams
  # GET /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
    @invite = Invite.new
    @invite.team_id = @team.id

    @pending_invitations = []
    @team.invites.each do |invite|
      unless @team.people.include?(invite.recipient) || invite.created_at != invite.updated_at
        @pending_invitations.push(invite)
      end
    end
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create

    # gcloud = Gcloud.new "gaffer"
    # storage = gcloud.storage
    # bucket = storage.bucket "gaffer-images"
    # file_url = params["team"]["logo"].tempfile.path
    #
    # bucket.create_file file_url, params["team"]["name"]

    @team = Team.new(team_params)
    @person = Person.find(params[:person_id])

    @team.save
    @team.add_creator(@person)

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def sweep_invites
    @team.invites.each do |invite|
      unless @team.people.include?(invite.recipient)
        invite.destroy
      end
    end

    respond_to do |format|
      format.html { redirect_to team_path(@team), notice: 'Deleted all pending invitations.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name, :color, :logo, :person_id)
    end

    # # https://coderwall.com/p/rqjjca/creating-a-scoped-invitation-system-for-rails
    # def invite_to
    #   emails = params[:invite_emails].split(', ')
    #   emails.each do |email|
    #     invite = Invite.new(:sender_id => current_person.id, :email => email, team_id => @team.id)
    #     if invite.save
    #       if invite.recipient != nil
    #         InviteMailer.existing_person_invite(invite).deliver
    #       else
    #         InviteMailer.new_person_invite(invite, new_person_registration_path(:invitation_token => @invite.token))
    #       end
    #     end
    # end
end
