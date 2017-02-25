class RegisterOnboardingController < ApplicationController
  before_action :authenticate_person!
  # layout "app"

  # steps :profile, :org, :payment

  def profile
    @person = current_person
  end

  def update_profile
    @person = current_person


    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to orgs_path, notice: 'Profile was successfully updated.' }
        format.js {}
      else
        format.html { render :edit }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end

  end


  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def person_params
    params.require(:person).permit(
      :first_name,
      :last_name,
      :avatar,
      :email,
      :phone,
      :date_of_birth,
      :street_address,
      :locality,
      :region,
      :postal_code
    )
  end

end
