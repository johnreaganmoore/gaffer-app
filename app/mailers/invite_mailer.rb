class InviteMailer < ApplicationMailer
  default from: 'gaffer@playonside.com'

  def new_person_invite(invite, url)
    @invite = invite
    @url = url

    @sender = Person.find(invite.sender_id)

    mail(
      to: @invite.email,
      subject: "#{@sender.first_name} #{@sender.last_name} wants to play soccer",
      tag: 'new-invite',
      track_opens: 'true'
    )
  end

  def new_person_resend_invite(invite, url)
    @invite = invite
    @url = url

    @sender = Person.find(invite.sender_id)

    mail(to: @invite.email, subject: "#{@sender.first_name} wants to play soccer with you")
  end

  def existing_person_invite(invite, url)
    @invite = invite
    @url = url

    @sender = Person.find(invite.sender_id)

    mail(to: @invite.email, subject: "Welcome to the #{@invite.team.name}")
  end

  def existing_person_resend_invite(invite, url)
    @invite = invite
    @url = url

    @sender = Person.find(invite.sender_id)

    mail(to: @invite.email, subject: "Welcome to the #{@invite.team.name}")
  end
end
