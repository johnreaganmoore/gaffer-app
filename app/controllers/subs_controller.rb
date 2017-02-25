class SubsController < ApplicationController
  layout "league_admin"

  def find
  end

  def select
    @client = Airtable::Client.new("key2NNwB4SDvGxGua")
    @players_table = @client.table('appk4jogku3roVOrI', 'Players')
    @players = @players_table.records

    @preferred_positions = []
    if query_params[:defender] then @preferred_positions.push("Defender") end
    if query_params[:midfielder] then @preferred_positions.push("Midfielder") end
    if query_params[:forward] then @preferred_positions.push("Forward") end
    if query_params[:goalkeeper] then @preferred_positions.push("Goalkeeper") end

    @preferred_sex = []
    if query_params[:male] then @preferred_sex.push("Male") end
    if query_params[:female] then @preferred_sex.push("Female") end


    @preferred_experience = []
    case query_params[:experience]
    when ""
      @preferred_experience = ["Beginner", "High School", "College/Advanced Club", "Professional"]
    when "beginner"
      @preferred_experience = ["Beginner", "High School", "College/Advanced Club", "Professional"]
    when "high-school"
      @preferred_experience = ["High School", "College/Advanced Club", "Professional"]
    when "college-club"
      @preferred_experience = ["College/Advanced Club", "Professional"]
    when "pro"
      @preferred_experience = ["Professional"]
    end

    @filtered_players = []
    @players.each do |player|
      if @preferred_sex.include?(player[:gender])
        if @preferred_experience.include?(player[:experience])
          if (player[:positions] & @preferred_positions).any?
            @filtered_players.push(player)
          end
        end
      end
    end

    @location = query_params[:location]
    @game_date = query_params[:game_date]
    @game_time = query_params[:game_time]

    @org = Org.last
    @person = Person.with_role(:admin, @org).first

  end

  # def email
  # end

  def query_params
    params.permit(:location, :game_date, :game_time, :goalkeeper, :defender, :midfielder, :forward, :male, :female, :experience)
  end

end
