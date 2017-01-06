class TransactionsController < ApplicationController

  def new
  end


=begin
  First season

  1. Update Merchant Account
  - Add external Account
  - Add Terms agreement time and IP

  2. Create customer

  3. Purchase_season

  4. Send T-shirt
=end

  def kickoff

    @token = params["stripeToken"]
    @team_season = TeamSeason.find(params["ts"])

    current_person.record_accept_terms(request.remote_ip)
    current_person.create_customer(@token)
    current_person.add_external_account
    current_person.purchase_season(@team_season)

    # redirect_to team_path(@team_season.team)
    redirect_to preview_season_path(@team_season)
    # IDEA: Instead of flash messages, at critical points give smooch popups. May need intercom for this.
    flash[:success] = "Welcome to the Onside, enjoy the season!"
  end

  def player_purchase
    @token = params["stripeToken"]
    @team_season = TeamSeason.find(params["ts"])

    if current_person
      @person = current_person
    else
      @person = Person.create_with_temp_pass(params["first_name"], params["last_name"], params["email"])
    end

    person_with_customer = @person.create_customer(@token)

    self.charge_customer(person_with_customer, @team_season)

    redirect_to confirm_team_season_path(@team_season.id)
    # IDEA: Instead of flash messages, at critical points give smooch popups. May need intercom for this.
    flash[:success] = "Welcome to the #{@team_season.team.name}, enjoy the season!"
  end

  def charge_customer(customer, team_season)
    result = customer.purchase_season(@team_season)
  end

end
