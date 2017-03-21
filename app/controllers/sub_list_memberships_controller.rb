class SubListMembershipsController < ApplicationController
  layout "subs"
  before_action :active_org

  require "csv"

  def new
    @person = Person.new
    @list = SubList.find(params[:list])
  end

  def create

    @person = Person.create_with_temp_pass(member_params[:first_name], member_params[:last_name], member_params[:email])

    @list = SubList.find(list_params[:sub_list_id])
    @membership = SubListMembership.find_or_create_by(person: @person, sub_list: @list)

    respond_to do |format|
      if @membership.save
        format.html { redirect_to edit_list_path(@list), notice: 'You successfully added a player to the list. Great job!' }
        # format.json { render :season_preview, status: :created, location: @membership }
      else
        format.html { render :new }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end

  end

  def batch
    puts "This is the batch action"
    @list = SubList.find(params[:list])
  end

  def batch_create
    @list = SubList.find(params[:list])
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

  def destroy
    @membership = SubListMembership.find(params[:id])
    @list = @membership.sub_list

    @membership.destroy
    respond_to do |format|
      format.html { redirect_to edit_list_path(@list), notice: 'Player was successfully removed from list.' }
      format.json { head :no_content }
    end
  end

  private

  def member_params
    params.require(:person).permit(:first_name, :last_name, :phone, :email)
  end

  # membership params can include stuff that is associated with a person, but only in the context of the list. For example:
  # Player rating.
  # Or notification preferences for this list.
  # in the future we will allow list managers to set their own membership properties like rating, experience level, positions, etc.
  def membership_params
    params.permit(:rating, :experience, positions: [])
  end

  def list_params
    params.require(:person).permit(:sub_list_id)
  end

  def batch_params
    params.permit(:file)
  end

end
