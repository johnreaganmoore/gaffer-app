class PersonMailer < ApplicationMailer
  default from: 'gaffer@playonside.com'

  def temp_password(person, generated_password)
    @person = person
    @generated_password = generated_password
    @team = person.teams.last
    @url = "http://playonside.com/sign_in"

    mail(to: @person.email, subject: "Welcome to the team")
  end

  def new_team_member(new_player, team_season)
    @person = new_player
    @url = preview_season_url(team_season)

    mail(to: team_season.treasurer.email, subject: "New Team Member")
  end

  def season_signup_notification(season, person)
    @season = season
    @person = person

    Person.with_role(:admin, @season.league.org).each do |admin|
      puts admin.inspect
      mail(to: admin.email, subject: "New Team registered for #{@season.league.name}")
    end

  end
end
