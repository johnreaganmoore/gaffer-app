class InvitesController < ApplicationController
  layout "relate"

  before_action :authenticate_person!, :only => :create
  # skip_filter :require_no_authentication, :only => :edit
  before_action :active_org, :set_current_person_tasks, :set_unassigned_tasks, :set_new_submissions, :get_due_tasks

  def new
    @invite = Invite.new

    if params[:team_id]
      @team = Team.find(params[:team_id])
    elsif params[:org_id]
      @org = Org.find(params[:org_id])
    end

  end


  def create
    @invite = Invite.new(invite_params)
    @invite.sender_id = current_person.id
    @invite.save

    if @invite.save
      # if person already exists
      if @invite.recipient != nil
        #send a notification email
        InviteMailer.existing_person_invite(@invite).deliver

        #Add the person to the team
        @invite.recipient.team_memberships.push(@invite.team_membership)
      else
        InviteMailer.new_person_invite(@invite, new_person_registration_url(:invitation_token => @invite.token)).deliver
      end

      respond_to do |format|
        format.html { redirect_to contacts_path, notice: 'Invitation sent successfully' }
        format.json { head :no_content }
        format.js {}
      end

    else
      print "Oh no, the invite failed to save"
      flash[:alert] = "Invitation failed to send"
    end
  end

  def destroy
    @invite = Invite.find(params[:id])
    @invite.destroy
    respond_to do |format|
      format.html { redirect_to team_path(@invite.team), notice: 'Invitation deleted.' }
      format.json { head :no_content }
    end
  end

  def resend
    @invite = Invite.find(params[:id])

      # if person already exists
      if @invite.recipient != nil
        #send a notification email
        InviteMailer.existing_person_resend_invite(@invite).deliver
        #Add the person to the team
        # @invite.recipient.team_memberships.push(@invite.team_membership)
      else
        InviteMailer.new_person_resend_invite(@invite, new_person_registration_path(:invitation_token => @invite.token)).deliver
      end

      flash[:notice] = "Invitation sent successfully"
      redirect_to team_path(@invite.team)
  end

  private

  def invite_params
    params.require(:invite).permit(:first_name, :last_name, :team_id, :org_id, :email)
  end
end
