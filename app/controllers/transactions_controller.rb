class TransactionsController < ApplicationController

  def new
  end


  def create
    nonce = 'fake-valid-nonce' # params["payment_method_nonce"]
    @team_season = TeamSeason.find(params["season"])

    base_cost = @team_season.new_player_cost
    service_fee = @team_season.new_player_cost * 0.10
    total_cost = base_cost + service_fee

    puts "service_fee: #{service_fee}"


    if current_person
      @person = current_person
    else
      @person = Person.create_with_temp_pass(params["first_name"], params["last_name"], params["email"])
    end

    unless @person.has_payment_info?
      @result = Braintree::Transaction.sale(
        merchant_account_id: @team_season.treasurer.id,
        amount: total_cost,
        service_fee_amount: service_fee,
        payment_method_nonce: 'fake-valid-nonce',
        customer: {
          first_name: @person.first_name,
          last_name: @person.last_name,
          email: @person.email
        },
        options: {
          store_in_vault: true,
          submit_for_settlement: true,
          hold_in_escrow: true
        }
      )
    else
      @result = Braintree::Transaction.sale(
        merchant_account_id: @team_season.treasurer.id,
        amount: total_cost,
        service_fee_amount: service_fee,
        payment_method_nonce: 'fake-valid-nonce',
        options: {
          submit_for_settlement: true,
          hold_in_escrow: true
        }
      )
    end

    if @result.success? || @result.transaction
      @person.update(braintree_customer_id: @result.transaction.customer_details.id) unless @person.has_payment_info?

      @person.purchase(@team_season, @result.transaction.amount)

      redirect_to team_path(@team_season.team.id)
      flash[:success] = "Welcome to the team, enjoy the season!"
    else
      error_messages = @result.errors.map { |error| "Error: #{error.code}: #{error.message}" }
      flash[:error] = error_messages
      redirect_to accept_season_path(@team_season)
    end
  end

  def _create_result_hash(transaction)
    status = transaction.status

    if TRANSACTION_SUCCESS_STATUSES.include? status
      result_hash = {
        :header => "Sweet Success!",
        :icon => "success",
        :message => "Your test transaction has been successfully processed. See the Braintree API response and try again."
      }
    else
      result_hash = {
        :header => "Transaction Failed",
        :icon => "fail",
        :message => "Your test transaction has a status of #{status}. See the Braintree API response and try again."
      }
    end
  end

end
