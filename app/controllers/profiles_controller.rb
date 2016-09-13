class ProfilesController < ApplicationController

  layout "app"

  before_action :set_person, only: [:show]

  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

end
