class SubsController < ApplicationController
  layout "subs"
  before_action :active_org

  require 'twilio-ruby'

  def find
    @org = @active_org
  end

  def select
    # @client = Airtable::Client.new("key2NNwB4SDvGxGua")
    # @players_table = @client.table('appk4jogku3roVOrI', 'Players')
    # @players = @players_table.records
    #
    # @preferred_positions = []
    # if query_params[:defender] then @preferred_positions.push("Defender") end
    # if query_params[:midfielder] then @preferred_positions.push("Midfielder") end
    # if query_params[:forward] then @preferred_positions.push("Forward") end
    # if query_params[:goalkeeper] then @preferred_positions.push("Goalkeeper") end
    #
    # @preferred_sex = []
    # if query_params[:male] then @preferred_sex.push("Male") end
    # if query_params[:female] then @preferred_sex.push("Female") end
    #
    #
    # @preferred_experience = []
    # case query_params[:experience]
    # when ""
    #   @preferred_experience = ["Beginner", "High School", "College/Advanced Club", "Professional"]
    # when "beginner"
    #   @preferred_experience = ["Beginner", "High School", "College/Advanced Club", "Professional"]
    # when "high-school"
    #   @preferred_experience = ["High School", "College/Advanced Club", "Professional"]
    # when "college-club"
    #   @preferred_experience = ["College/Advanced Club", "Professional"]
    # when "pro"
    #   @preferred_experience = ["Professional"]
    # end
    #
    #
    # case query_params[:last_contacted]
    # when ""
    #   @contact_cutoff = Date.today-2.years
    # when "any"
    #   @contact_cutoff = Date.today-2.years
    # when "1-days"
    #   @contact_cutoff = Date.today-1.day
    # when "2-days"
    #   @contact_cutoff = Date.today-2.days
    # when "3-days"
    #   @contact_cutoff = Date.today-3.days
    # when "4-days"
    #   @contact_cutoff = Date.today-4.days
    # when "5-days"
    #   @contact_cutoff = Date.today-5.days
    # when "1-weeks"
    #   @contact_cutoff = Date.today-1.week
    # when "2-weeks"
    #   @contact_cutoff = Date.today-2.weeks
    # end
    #
    # case query_params[:last_subbed]
    # when ""
    #   @subbed_cutoff = Date.today-2.years
    # when "any"
    #   @subbed_cutoff = Date.today-2.years
    # when "1-days"
    #   @subbed_cutoff = Date.today-1.day
    # when "2-days"
    #   @subbed_cutoff = Date.today-2.days
    # when "3-days"
    #   @subbed_cutoff = Date.today-3.days
    # when "4-days"
    #   @subbed_cutoff = Date.today-4.days
    # when "5-days"
    #   @subbed_cutoff = Date.today-5.days
    # when "1-weeks"
    #   @subbed_cutoff = Date.today-1.week
    # when "2-weeks"
    #   @subbed_cutoff = Date.today-2.weeks
    # end
    #
    #
    #
    # puts @contact_cutoff
    # puts @subbed_cutoff
    #
    # @filtered_players = []
    # @players.each do |player|
    #   if @preferred_sex.include?(player[:gender])
    #     if @preferred_experience.include?(player[:experience])
    #       if (player[:positions] & @preferred_positions).any?
    #
    #         if player[:last_subbed] == ""
    #           player[:last_subbed] = "1989-10-04"
    #         end
    #
    #         if player[:last_emailed] == ""
    #           player[:last_emailed] = "1989-10-04"
    #         end
    #
    #         if player[:last_subbed].to_date < @subbed_cutoff && player[:last_emailed].to_date < @contact_cutoff
    #           @filtered_players.push(player)
    #         end
    #       end
    #     end
    #   end
    # end


    # @filterrific = initialize_filterrific(
    #   Person,
    #   params[:filterrific],
    #   select_options: {
    #     sorted_by: Person.options_for_sorted_by,
    #     with_any_sub_list_ids: SubLists.options_for_select
    #   },
    #   persistence_id: 'shared_key',
    #   default_filter_params: {},
    #   available_filters: [],
    # ) or return



    lists = []

    list_array = query_params[:lists] ? query_params[:lists].split(",") : []

    list_array.each do |id_string|
      sub_list = SubList.find(id_string.to_i)
      lists.push(sub_list)
    end

    @filtered_players = []
    lists.each do |list|
      @filtered_players = @filtered_players | list.people
    end

    @location = query_params[:location] ? query_params[:location] : "Somewhere"
    @game_date = query_params[:game_date] ? query_params[:game_date] : "Someday"
    @game_time = query_params[:game_time] ? query_params[:game_time] : "Sometime"

    @org = Org.last
    @person = Person.with_role(:admin, @org).first

  end

  def email
    # @client = Airtable::Client.new("key2NNwB4SDvGxGua")
    # @players_table = @client.table('appk4jogku3roVOrI', 'Players')

    players_to_email = []
    recipient_ids = email_params[:recipients].split(/\s*,\s*/)
    recipient_ids.each do |recipient|
      @player = Person.find(recipient)

      # if @player.phone
      #   puts "PHONE"
      #
      #   smsBody = "Hey #{@player.first_name}," + "\n" + "\n" + email_params[:sms]
      #
      #   @twilio_client = Twilio::REST::Client.new ENV["twilio_sid"], ENV["twilio_token"]
      #   message = @twilio_client.account.messages.create(
      #     body: smsBody,
      #     to: "+1#{@player.phone}",
      #     from: "+19782245083"
      #   )
      #
      # else
      #   puts "EMAIL"
        if @player.first_name
          players_to_email << {email: @player.email, first_name: @player.first_name, last_name: @player.last_name}
        elsif @player.last_name
          players_to_email << {email: @player.email, first_name: "there", last_name: @player.last_name}
        else
          players_to_email << {email: @player.email, first_name: "there", last_name: "player"}
        end
      # end
    end

    puts players_to_email.inspect

    current_person.send_sub_email(session[:admin_org], players_to_email, email_params[:subject], email_params[:body])

    redirect_to find_subs_path, notice: 'You emailed players, great job! You should receive their responses directly.'
  end

  def query_params
    params.permit(:location, :game_date, :game_time, :goalkeeper, :defender, :midfielder, :forward, :male, :female, :experience, :last_subbed, :last_contacted, :lists)
  end

  def email_params
    params.permit(:from, :subject, :body, :recipients, :sms)
  end

end
