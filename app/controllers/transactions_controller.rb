class TransactionsController < ApplicationController

  def new
  end


  def create
    nonce = 'fake-valid-nonce'
    # nonce = params["payment_method_nonce"]

    @team_season = TeamSeason.find(params["season"])

    if current_person
      @person = current_person
    else
      @person = Person.create_with_temp_pass(params["first_name"], params["last_name"], params["email"])
    end

    @result = @person.purchase_season(@team_season, nonce)

    if @result.class == Braintree::SuccessfulResult || Braintree::ErrorResult
      if @result.success? || @result.transaction
        @person.update(braintree_customer_id: @result.transaction.customer_details.id) unless @person.has_payment_info?

        redirect_to confirm_team_season_path(@team_season.id)
        flash[:success] = "Welcome to the team, enjoy the season!"
      else
        error_messages = @result.errors.map { |error| "Error: #{error.code}: #{error.message}" }
        flash[:error] = error_messages
        redirect_to accept_season_path(@team_season)
      end
    else
      if @result[:success]
        redirect_to confirm_team_season_path(@team_season.id)
        flash[:success] = "You have already paid and were not charged again. Enjoy the season!"
      end
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
