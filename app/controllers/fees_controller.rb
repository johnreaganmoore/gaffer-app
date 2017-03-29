class FeesController < ApplicationController
  layout "app"

  before_action :active_org

  def index
    @fees = Fee.order('created_at DESC')
    @team = @fees[0].team
  end

  def new
    @fee = Fee.new
    @team = Team.find(params[:team])
  end

  def create
    @fee = Fee.create(
      label: fee_params[:label],
      total_amount: fee_params[:total_amount].to_i * 100,
      player_amount: fee_params[:player_amount].to_i * 100,
      team_id: fee_params[:team_id],
    )
    if @fee.save
      @fee.team.people.each do |player|
        pamount = fee_params[:player_amount].to_i * 100

        @pfee = PlayerFee.create(fee: @fee, person: player, amount: pamount, paid: false)
        if @pfee.save
          @pfee.notify(current_person)
          # email the player with a link to the show page for player fees: player_fee_path(@pfee)
        end
      end
      redirect_to confirm_fee_path(@fee)
    else
      render 'new'
    end
  end

  def show
    @fee = Fee.find(params[:id])
    @team = @fee.team
  end

  def confirm
    @fee = Fee.find(params[:id])
    @team = @fee.team
  end

  private

  def fee_params
    params.require(:fee).permit(:label, :total_amount, :player_amount, :team_id)
  end

end
