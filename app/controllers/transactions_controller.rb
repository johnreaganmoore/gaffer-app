class TransactionsController < ApplicationController

  def new
    if current_person
      @person = current_person
    else
      @person = Person.new
    end

    @season = Season.find(params[:season])
  end


  def connect_subscribe
    @token = params["stripeToken"]
    @person = current_person

    if params[:plan]
      person_with_customer = @person.create_customer(@token)
      person_with_customer.subscribe_to_plan(params[:plan])
    end

    redirect_to orgs_path

    # if @token
    #   redirect_to orgs_path
    # else
    #   redirect_to orgs_path
    # end

    # IDEA: Instead of flash messages, at critical points give smooch popups. May need intercom for this.
    # flash[:success] = "Welcome to Onside!"
  end

  def update_subscription
    @plan = params["plan"]
    @token = params["stripeToken"]
    @person = current_person

    unless @person.customer_id
      @person.create_customer(@token)
    end

    subscription = @person.update_subscription(@plan)

    redirect_to account_path(current_person)
    flash[:success] = "Great, you updated your plan"

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

    # @token = params["stripeToken"]
    # @team_season = TeamSeason.find(params["ts"])
    #
    # current_person.record_accept_terms(request.remote_ip)
    # current_person.create_customer(@token)
    # current_person.add_external_account
    # current_person.purchase_season(@team_season)

    # redirect_to team_path(@team_season.team)
    # redirect_to preview_season_path(@team_season)

    redirect_to contacts_path

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

  def player_fee_payment
    @token = params["stripeToken"]
    @player_fee = PlayerFee.find(params["pf"])

    if current_person
      @person = current_person
    else
      @person = Person.create_with_temp_pass(params["first_name"], params["last_name"], params["email"])
    end

    person_with_customer = @person.create_customer(@token)

    @person.pay_fee(@player_fee)

    redirect_to confirm_pay_fee_path(@player_fee.id)
    # IDEA: Instead of flash messages, at critical points give smooch popups. May need intercom for this.
  end



  def charge_customer(customer, team_season)
    result = customer.purchase_season(team_season, team_season.treasurer.merchant_account_id, team_season.new_player_cost)
  end


# TODO finish this method to allow the captain to complete the season purchase. On completion take them to a success page.
  def purchase_team_season(season)
    @token = params["stripeToken"]

    @team = Team.create_random
    @team_season = TeamSeason.create(team_id: @team.id, season_id: season.id, cost: season.cost, min_players: season.league.players_per_team)

    if current_person
      @captain = current_person
    else
      @captain = Person.create_with_temp_pass(params["first_name"], params["last_name"], params["email"])
    end
    @captain = @captain.create_customer(@token)

    result = @captain.purchase_season(@team_season, season.league.org.merchant_account_id, season.cost)

    redirect_to team_season_confirm_team_path(@team_season.id)

    flash[:success] = "Great, you're signed up. We'll be in touch with you shortly. Enjoy the season!"

    PersonMailer.season_signup_notification(season, @captain).deliver

    return result

  end

end
