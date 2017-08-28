class Contact < ApplicationRecord
  belongs_to :org
  acts_as_taggable

  has_many :notes
  has_many :reminders
  has_many :contact_values, inverse_of: :contact, dependent: :destroy
  accepts_nested_attributes_for :contact_values

  before_save :set_tag_owner
  def set_tag_owner
    # Set the owner of some tags based on the current tag_list
    set_owner_tag_list_on(self.org, :tags, self.tag_list)
    # Clear the list so we don't get duplicate taggings
    self.tag_list = nil
  end

  def next_reminder
    next_overall_date = nil
    self.reminders.each do |reminder|
      if reminder.status != "archived"
        if next_overall_date == nil || reminder.next_date > next_overall_date
          next_overall_date = reminder.next_date
        end
      end
    end
    return next_overall_date
  end

  def latest_activity
    latest_date = self.updated_at

    reminder_date = latest_date
    if self.reminders.length > 0
      reminder_date = self.reminders.sort_by(&:updated_at).first.updated_at
    end

    note_date = latest_date
    if self.notes.length > 0
      note_date = self.notes.sort_by(&:updated_at).first.updated_at
    end

    # reminder_date = self.reminders.first(:order => "updated_at DESC")
    # note_date = self.notes.first(:order => "updated_at DESC")

    if reminder_date > latest_date
      latest_date = reminder_date
    end

    if note_date > latest_date
      latest_date = note_date
    end

    return latest_date

  end

  def activities
    acts = self.notes + self.reminders
    return acts.sort!{|b,a| a.updated_at <=> b.updated_at}
  end

  filterrific :default_filter_params => { :sorted_by => 'updated_at_desc' },
            :available_filters => %w[
              sorted_by
              search_query
              has_tags
            ]

  scope :search_query, lambda { |query|
    return nil  if query.blank?
    # condition query, parse into individual keywords
    terms = query.downcase.split(/\s+/)
    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
      (e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conditions = 3
    where(
      terms.map {
        or_clauses = [
          "LOWER(contacts.first_name) LIKE ?",
          "LOWER(contacts.last_name) LIKE ?",
          "LOWER(contacts.email) LIKE ?"
        ].join(' OR ')
        "(#{ or_clauses })"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conditions }.flatten
    )
  }

  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^updated_at_/
      order("contacts.updated_at #{ direction }")
    when /^name_/
      order("LOWER(contacts.last_name) #{ direction }, LOWER(contacts.first_name) #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  scope :has_tags, lambda { |tag_ids|
    puts tag_ids
    Contact.tagged_with(tag_ids, :any => true)
  }

  def self.options_for_sorted_by
    [
      ['Name (a-z)', 'name_asc'],
      ['Newest updated (newest first)', 'updated_at_desc'],
      ['Oldest Update (oldest first)', 'updated_at_asc'],
    ]
  end

  def self.options_for_tag_list
    [
      "Software Partner",
      "Recruit",
      "Player",
      "Alumnus"
    ]
  end

  def send_email(subject, body, sender)

    mg_client = Mailgun::Client.new ENV['mailgun_api_key']

      # Define your message parameters
    message_params =  {
                        from: sender.email,
                        to:   self.email,
                        subject: subject,
                        text: body,
                      }

    # Send your message through the client
    mg_client.send_message 'mail.playonside.com', message_params

    Note.create(
      creator_id: sender.id,
      contact_id: self.id,
      body: "<b><h3>Sent Email</h3></b><br>
            <br>
            <div><b>Subject:</b> #{subject}</div>
            <div><b>Body:</b> #{body}</div>"
          )
  end

  def send_batch_email(recipients, subject, body, sender)
    puts org.inspect, recipients.inspect, subject, body
    mg_client = Mailgun::Client.new ENV['mailgun_api_key']

    # Create a Batch Message object, pass in the client and your domain.
    mb_obj = Mailgun::BatchMessage.new(mg_client, "mail.playonside.com")

    # Define the from address.
    mb_obj.from(sender.email, {"first"=>sender.first_name, "last" => sender.last_name});

    # Define the subject.
    mb_obj.subject(subject);

    # Define the body of the message.
    mb_obj.body_text(body);

    # Loop through all of your recipients
    recipients.each do |recipient|
      mb_obj.add_recipient(:to, recipient[:email], {"first" => recipient.first_name, "last" => recipient.last_name});
    end

    # Call finalize to get a list of message ids and totals.
    message_ids = mb_obj.finalize
    # {'id1234@example.com' => 1000, 'id5678@example.com' => 15}

  end


end
