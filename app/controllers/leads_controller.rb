class LeadsController < ApplicationController

  def create

    @lead = Lead.create(lead_params)

    respond_to do |format|
      if @lead.save
        format.html { redirect_to season_path(@season), notice: 'Season was successfully created.' }
        format.json { render :season_preview, status: :created, location: @season }
        format.js {}
      else
        format.html { render :new }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def lead_params
    params.require(:lead).permit(
      :email,
    )
  end

end
