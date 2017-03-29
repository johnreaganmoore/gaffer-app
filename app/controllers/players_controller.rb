class PlayersController < ApplicationController
  before_action :authenticate_person!, :active_org

  layout "app"

  def new
    @person = Person.new
    @team = Team.find(params[:team])

    @team_membership = TeamMembership.create(team: @team)

  end

  def create

    @team_membership = TeamMembership.find(person_params.dig("team_membership", "id"))

    @person = Person.create_with_temp_pass(person_params[:first_name], person_params[:last_name], person_params[:email])

    # @person = Person.find_or_create_by(email: person_params[:email]) do |person|
    #   person.first_name = person_params[:first_name]
    #   person.last_name = person_params[:last_name]
    # end
    #
    # puts "this is the person"

    # @person.save

    puts @person.inspect

    @team_membership.person_id = @person.id

    puts @team_membership.inspect

    if @team_membership.save

      puts "person saved"
      puts @person
      puts @team_membership.inspect

      redirect_to @team_membership.team, notice: 'You added a new player. Great.'
    else
      render :new
    end


  end


  def batch
    @team = Team.find(params[:team])
  end

  def batch_create
    @team = Team.find(params[:team])
    puts batch_params[:file]

    file = batch_params[:file]

    puts file.inspect

    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      puts row["Email"]
      # row.keys.each do |key|
      #   key.parameterize.underscore.downcase
      # end

      puts row.inspect
      puts row.class
      puts row[:email]
      puts row["email"]
      puts row["Email"]
      # product = find_by(id: row["id"]) || new
      # product.attributes = row.to_hash
      # product.save!
    end

    CSV.foreach(file.path, headers: true) do |row|
      puts row.inspect
      puts row[0], row[1], row[2]

      @person = Person.create_with_temp_pass(row[1], row[2], row[0])
      @membership = SubListMembership.find_or_create_by(person: @person, sub_list: @list)
      @membership.save

    end

    redirect_to edit_list_path(@list), notice: 'You successfully added players to the list. Great job!'
  end










  private
    # Use callbacks to share common setup or constraints between actions.

    def person_params
      params.require(:person).permit(
        :email,
        :first_name,
        :last_name,
        team_membership: [
          :id
        ]
      )
    end

    def team_membership_params
      params.require(:team_membership).permit(
        :id
      )
    end

end
