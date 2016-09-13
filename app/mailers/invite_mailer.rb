class InviteMailer < ApplicationMailer
  default from: 'johnreaganmoore+gaffer@gmail.com'

  def new_person_invite(invite, url)
    @invite = invite
    @url = url

    @sender = Person.find(invite.sender_id)

    puts @sender
    puts @sender.first_name
    puts @invite.team.name

    mail(to: @invite.email, subject: "Welcome to the #{@invite.team.name}")
  end

  def new_person_resend_invite(invite, url)
    @invite = invite
    @url = url

    @sender = Person.find(invite.sender_id)

    puts @sender
    puts @sender.first_name
    puts @invite.team.name

    mail(to: @invite.email, subject: "Welcome to the #{@invite.team.name}")
  end

  def existing_person_invite(invite, url)
    @invite = invite
    @url = url

    @sender = Person.find(invite.sender_id)

    puts @sender
    puts @sender.first_name
    puts @invite.team.name

    mail(to: @invite.email, subject: "Welcome to the #{@invite.team.name}")
  end

  def existing_person_resend_invite(invite, url)
    @invite = invite
    @url = url

    @sender = Person.find(invite.sender_id)

    puts @sender
    puts @sender.first_name
    puts @invite.team.name

    mail(to: @invite.email, subject: "Welcome to the #{@invite.team.name}")
  end
end
