class Api::V1::ContactsController < Api::V1::BaseController
  include ActiveHashRelation

  def index
    @contacts = Contact.all
    @contacts = apply_filters(@contacts, params)

    serialized_array = []

    @contacts.each do |con|
      serialized_array.push(Api::V1::ContactSerializer.new(con))
    end

    render json: serialized_array.to_json

  end

  def show

    puts current_person

    @contact = Contact.find(params[:id])

    render(json: Api::V1::ContactSerializer.new(@contact).to_json)
  end

  def create

    @contact = Contact.new(contact_params)
    @contact.org_id = current_person.administered_orgs[0].id

    if @contact.save
      render json: @contact, status: 201
      # format.json { render :show, status: :created, location: @contact }
    else
      format.json { render json: @contact.errors, status: :unprocessable_entity }
    end

  end

end

def contact_params
  params.require(:contact).permit(:first_name, :last_name, :phone, :email, :tag_list, :contact_values_attributes => [:id, :value, :date_value, :number_value, :contact_property_id])
end
