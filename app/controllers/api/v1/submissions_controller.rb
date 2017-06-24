class Api::V1::SubmissionsController < Api::V1::BaseController
  include ActiveHashRelation

  def index
    @active_org = current_person.administered_orgs[0]
    @submissions = @active_org.submissions.order('updated_at DESC')

    @submissions = apply_filters(@submissions, params)

    serialized_array = []

    @submissions.each do |con|
      serialized_array.push(Api::V1::SubmissionSerializer.new(con))
    end

    render json: serialized_array.to_json

  end

  def show

    @submission = Submission.find(params[:id])

    render(json: Api::V1::SubmissionSerializer.new(@submission).to_json)
  end

  def create
    @active_org = current_person.administered_orgs[0]

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

    @submission = Submission.new(formatted_params)
    @submission.org_id = @active_org.id

    if @submission.save
      render json: @submission, status: 201
      # format.json { render :show, status: :created, location: @submission }
    else
      format.json { render json: @submission.errors, status: :unprocessable_entity }
    end

  end

  private

  def submission_params
    keys = []
    @active_org.contact_properties.each do |cp|
      keys << cp.property.downcase.tr(' ', '_')
    end

    params.require(:contact).permit(:first_name, :last_name, :phone, :email, :status, contact_values_attributes: keys)
  end
end
