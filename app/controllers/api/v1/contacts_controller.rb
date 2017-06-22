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
    @active_org = current_person.administered_orgs[0]

    # puts params[:contact_values_attributes].inspect

    # params[:contact_values_attributes].each do |cv|
    #   puts cv.inspect
    #   con_val = ContactValue.create(cv)
    #   puts con_val
    # end

    # puts "Contact params inspection:", contact_params.inspect

    puts "Yo0oooooooooooooooo:", contact_params[:contact_values_attributes].inspect

    contact_values_array = []

    contact_params[:contact_values_attributes].each do |k,v|
      puts "Key", k

      @cp = ContactProperty.find_by(org_id: @active_org.id, property: k.titleize.tr('_', ' '))

      puts @cp.inspect

      puts "value:", v

      if @cp.data_type == "number"
        contact_values_array << {contact_property_id: @cp.id, number_value: v}
      elsif @cp.data_type == "date"
         contact_values_array << {contact_property_id: @cp.id, date_value: v}
      else
        contact_values_array << {contact_property_id: @cp.id, value: v}
      end

    end

    formatted_params = contact_params

    formatted_params[:contact_values_attributes] = contact_values_array

    @contact = Contact.new(formatted_params)
    @contact.org_id = @active_org.id

    if @contact.save
      render json: @contact, status: 201
      # format.json { render :show, status: :created, location: @contact }
    else
      format.json { render json: @contact.errors, status: :unprocessable_entity }
    end

  end

  private

  def contact_params
    # puts params[:contact_values_attributes].inspect
    # puts params.inspect

    # params.require(:contact).permit(:name,  { project_criteria: [:name, :type, :benefit]} )
    # params.require(:contact).permit(:first_name, :last_name, :phone, :email, :tag_list, { contact_values: [:id, :value, :date_value, :number_value, :contact_property_id]})

    keys = []

    @active_org.contact_properties.each do |cp|
      keys << cp.property.downcase.tr(' ', '_')
    end

    # puts "Checkout active_org contact properties:", keys.inspect

    params.require(:contact).permit(:first_name, :last_name, :phone, :email, :tag_list, contact_values_attributes: keys)
  end
end
