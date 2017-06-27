class PlayerFee < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :person
  belongs_to :fee

  def notify(sender)
    mg_client = Mailgun::Client.new ENV['mailgun_api_key']

    mb_obj = Mailgun::MessageBuilder.new()

    # Define the from address.
    mb_obj.from(sender.email, {first: sender.first_name, last: sender.last_name});

    # Define a to recipient.
    mb_obj.add_recipient(:to, self.person.email, {first: self.person.first_name, last: self.person.last_name});

    # Define the subject.
    mb_obj.subject("Hey #{self.person.first_name}, here is the #{self.fee.label}");

    # Define the body of the message.
    mb_obj.body_text(
      "Hey #{self.person.first_name},
      \nThanks for being a part of the team, here is a link to the page to make the payment for #{self.fee.label}:
      \nhttp://collect.gaffer_app.dev/player_fees/#{self.id}
      \nIf you have any questions, let me know.
      \nThanks,
      \n#{sender.first_name} #{sender.last_name}
      "
    );

    # Set the Message-Id header, provide a valid Message-Id.
    # mb_obj.message_id("<20141014000000.11111.11111@example.com>")

    # Or clear the Message-Id header, provide nil or empty string.
    mb_obj.message_id(nil)
    # mb_obj.message_id('')
    #
    # # Campaigns and headers.
    # mb_obj.add_campaign_id("My-Awesome-Campaign");
    # mb_obj.header("Customer-Id", "12345");
    #
    # # Custom variables
    # mb_obj.variable("Customer-Data", { :first_name => "John", :last_name => "Smith" })
    #
    # # Attach a file and rename it.
    # mb_obj.add_attachment "/path/to/file/receipt_123491820.pdf", "Receipt.pdf"
    #
    # # Attach an image inline.
    # mb_obj.add_inline_image "/path/to/file/header.png"
    #
    # # Schedule message in the future
    # mb_obj.deliver_at("tomorrow 8:00AM PST");

    # Finally, send your message using the client
    result = mg_client.send_message("playonside.com", mb_obj)

    puts result.body.to_s


  end
end
