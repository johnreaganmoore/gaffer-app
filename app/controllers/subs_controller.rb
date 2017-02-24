class SubsController < ApplicationController


  def find
  end

  def select
    @client = Airtable::Client.new("key2NNwB4SDvGxGua")
    @players_table = @client.table('appk4jogku3roVOrI', 'Players')
    @players = @players_table.records
    @filtered_players = []
    @players.each do |player|
      if player[:positions].include?("Forward")
        @filtered_players.push(player)
      end
    end
  end

  # def email
  # end


end
