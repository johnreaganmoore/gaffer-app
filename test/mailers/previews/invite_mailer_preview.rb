# Preview all emails at http://localhost:3000/rails/mailers/invite_mailer
class InviteMailerPreview < ActionMailer::Preview

  def new_person_invite
    InviteMailer.new_person_invite(Invite.first, "localhost:3000/register?invitation_token=#{Invite.first.token}")
  end
end
