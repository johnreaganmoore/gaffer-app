class SubmissionsController < ApplicationController
  layout "relate"

  before_action :authenticate_person!
  before_action :active_org, :set_current_person_tasks, :set_unassigned_tasks, :set_new_submissions, :get_due_tasks

  def index
    # @new_submissions = @active_org.submissions.where(status: "new").order('updated_at DESC')
    @approved_submissions = @active_org.submissions.where(status: "approved").order('updated_at DESC')
    @rejected_submissions = @active_org.submissions.where(status: "rejected").order('updated_at DESC')
    @maybe_submissions = @active_org.submissions.where(status: "maybe").order('updated_at DESC')

    @contacts = @active_org.contacts

  end

  def update

    @submission = Submission.find(params[:id])

    submission_values_array = []

    if submission_params[:contact_values_attributes]
      submission_params[:contact_values_attributes].each do |k,v|

        @cp = ContactProperty.find_by(org_id: @active_org.id, property: k.titleize.tr('_', ' '))

        if @cp.data_type == "number"
          submission_values_array << {contact_property_id: @cp.id, number_value: v}
        elsif @cp.data_type == "date"
           submission_values_array << {contact_property_id: @cp.id, date_value: v}
        else
          submission_values_array << {contact_property_id: @cp.id, value: v}
        end
      end
    end

    formatted_params = submission_params
    formatted_params[:submission_values_attributes] = submission_values_array
    formatted_params.delete(:contact_values_attributes)

    puts formatted_params

    respond_to do |format|
      if @submission.update(formatted_params)

        @new_submissions = @active_org.submissions.where(status: "new").order('updated_at DESC')
        @approved_submissions = @active_org.submissions.where(status: "approved").order('updated_at DESC')
        @rejected_submissions = @active_org.submissions.where(status: "rejected").order('updated_at DESC')
        @maybe_submissions = @active_org.submissions.where(status: "maybe").order('updated_at DESC')

        format.js {}
      else
        format.html { render :index }
        format.js { render :index }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def submission_params
    keys = []
    @active_org.contact_properties.each do |cp|
      keys << cp.property.downcase.tr(' ', '_')
    end

    params.require(:submission).permit(:first_name, :last_name, :phone, :email, :status, contact_values_attributes: keys)
  end

end
