class WebhooksController < ApplicationController

  skip_before_action :verify_authenticity_token

  def recieve
    notification = Braintree::WebhookNotification.parse(
      request.params["bt_signature"],
      request.params["bt_payload"]
    )

    puts "[Webhook Received #{notification.timestamp}] Kind: #{notification.kind}"

    if notification.kind == Braintree::WebhookNotification::
                       Kind::SubMerchantAccountApproved
        # true
        notification.merchant_account.status
        # "active"
        notification.merchant_account.id
        # "blue_ladders_store"
        notification.merchant_account.master_merchant_account.id
        # "14ladders_marketplace"
        notification.merchant_account.master_merchant_account.status
        # "active"

        puts "Excellent, the sub-merchant account was successfully created.
         The merchant_account is is #{notification.merchant_account.id},
          and it is now #{notification.merchant_account.status}"

    elsif notification.kind == Braintree::WebhookNotification::
                       Kind::SubMerchantAccountDeclined

       puts "Shoot, this merchant_account wans't created. Here's why: #{notification.message}"

       # true
       notification.message
       # "Credit score is too low"
       notification.errors
       # #<Braintree::ErrorResult params:{. . .} errors:<merchant_account:[(82621) Applicant declined due to OFAC.]>>

    else
      puts "Whoa, something is messed up with this webhook. Checkout the webhook controller."
    end

    return 200
  end

end
