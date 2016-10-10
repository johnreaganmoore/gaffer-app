class WebhooksController < ApplicationController

  skip_before_action :verify_authenticity_token

  def recieve
    webhook_notification = Braintree::WebhookNotification.parse(
      request.params["bt_signature"],
      request.params["bt_payload"]
    )
    puts "[Webhook Received #{webhook_notification.timestamp}] Kind: #{webhook_notification.kind}"
    return 200
  end

end
