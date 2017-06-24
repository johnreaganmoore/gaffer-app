class SubmissionsController < ApplicationController
  layout "relate"

  before_action :authenticate_person!
  before_action :active_org

  def index
    @submissions = @active_org.submissions.order('updated_at DESC')
  end

end
