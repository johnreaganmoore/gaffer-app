class PlayerFeesController < ApplicationController
  before_action :active_org, except: [:show]

  layout "fees", only: [:show]

  # def index
  #   @fees = Fee.order('created_at DESC')
  # end

  def new
    @player_fee = PlayerFee.new
    @fee = Fee.find(params[:fee])
  end

  def create
    @player_fee = PlayerFee.create(player_fee_params)
    if @player_fee.save
      redirect_to team_path(@fee.team)
    else
      render 'new'
    end
  end

  def show
    @player_fee = PlayerFee.find(params[:id])
    @team = @player_fee.fee.team

    if current_person
      @person = current_person
    else
      @person = @player_fee.person
    end
  end

  def confirm
    @player_fee = PlayerFee.find(params[:id])
  end

  private

  def player_fee_params
    params.require(:player_fee).permit(:fee, :person, :paid, :charge, :amount)
  end

end
