class PersonMailer < ApplicationMailer
  default from: 'johnreaganmoore+gaffer@gmail.com'

  def temp_password(person, generated_password)
    @person = person
    @generated_password = generated_password
    @team = person.teams.last

    mail(to: @person.email, subject: "Welcome to the team")
  end

end