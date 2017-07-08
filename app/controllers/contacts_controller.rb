class ContactsController < ApplicationController
  before_action :authenticate_person!
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_action :active_org, :set_current_person_tasks, :set_unassigned_tasks, :set_new_submissions, :get_due_tasks

  layout "relate"

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = @active_org.contacts

    @table_property_names = @active_org.contact_properties.ids

    @email_templates = @active_org.email_templates
    @template_select_options = [['Blank Email', "0", {disabled: false, selected: true}]]
    @active_org.email_templates.each do |template|
      @template_select_options << ["#{template.name}","#{template.id}"]
    end


    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    @reminder = Reminder.new
    @note = Note.new
    @email = {}
    @activities = @contact.activities
    @tasks = @contact.reminders.where.not(status: "archived").order(:next_date)

    available_admins = @active_org.admins
    # available_admins.delete(current_person)

    # @admins_options = [
    #   ["#{current_person.first_name} #{current_person.last_name}", current_person.id, {disabled: false, selected: true}],
    # ]
    @admins_options = [["Unnassigned", nil]]

    available_admins.each do |admin|
      @admins_options << ["#{admin.first_name} #{admin.last_name}", admin.id]
    end

    puts @admins_options

    @email_templates = @active_org.email_templates

    @template_select_options = [['Blank Email', "0", {disabled: false, selected: true}]]

    @active_org.email_templates.each do |template|
      @template_select_options << ["#{template.name}","#{template.id}"]
    end

  end

  # GET /contacts/new
  def new
    @contact = Contact.new

    @active_org.contact_properties.each do |cp|
      @contact.contact_values.build(contact_property_id: cp.id)
    end

  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  # POST /contacts.json
  def create

    puts contact_params.inspect

    @contact = Contact.new(contact_params)
    @contact.org_id = @active_org.id

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def batch_create
    # @list = SubList.find(params[:list])
    puts batch_params[:file]

    file = batch_params[:file]
    org_id = batch_params[:org_id]

    puts file.inspect
    puts org_id

    # First Name":"Ian"
    # "Last Name":"Zogg"
    # "Email":nil
    # "Phone":nil
    #
    # "Last Contact Date":nil
    # "Last Contact Note":nil
    # "Class":"2019"
    # "Birthday":nil
    # "Xtain?":"?"
    # "Position":"HM"
    # "PE":"1.5"
    # "City":nil
    # "State":nil
    # "Address":nil
    # "Club Team":"GPS Maine '01"
    # "High School":nil
    # "Comments":"Saw game on 4/9/17, Not too many notes, but caught my eye somehow."

    CSV.foreach(file.path, headers: true) do |row|
      puts "Isnpecting row:"
      puts row.inspect
      puts row.headers[0], row[1], row[2]


      @contact = Contact.create(
        org_id: org_id,
        first_name: row[0],
        last_name: row[1],
        email: row[2],
        phone: row[3]
      )

      @contact.tag_list.add("Recruit")
      @contact.save

      @class_prop = ContactProperty.find_or_create_by(org_id: org_id, property: "Class")
      # ContactValue.create(contact: @contact, contact_property: @class_prop, value: row[6])
      cv = ContactValue.where(contact: @contact, contact_property: @class_prop,).first_or_initialize
      cv.value = row[6]
      cv.save

      @birthday_prop = ContactProperty.find_or_create_by(org_id: org_id, property: "Birthday")
      cv = ContactValue.where(contact: @contact, contact_property: @birthday_prop,).first_or_initialize
      cv.value = row[7]
      cv.save

      @x_prop = ContactProperty.find_or_create_by(org_id: org_id, property: "Christian?")
      cv = ContactValue.where(contact: @contact, contact_property: @x_prop,).first_or_initialize
      cv.value = row[8]
      cv.save

      @position_prop = ContactProperty.find_or_create_by(org_id: org_id, property: "Position")
      cv = ContactValue.where(contact: @contact, contact_property: @position_prop,).first_or_initialize
      cv.value = row[9]
      cv.save

      @pe_prop = ContactProperty.find_or_create_by(org_id: org_id, property: "PE")
      cv = ContactValue.where(contact: @contact, contact_property: @pe_prop,).first_or_initialize
      cv.value = row[10]
      cv.save

      @city_prop = ContactProperty.find_or_create_by(org_id: org_id, property: "City")
      cv = ContactValue.where(contact: @contact, contact_property: @city_prop,).first_or_initialize
      cv.value = row[11]
      cv.save

      @state_prop = ContactProperty.find_or_create_by(org_id: org_id, property: "State")
      cv = ContactValue.where(contact: @contact, contact_property: @state_prop,).first_or_initialize
      cv.value = row[12]
      cv.save

      @address_prop = ContactProperty.find_or_create_by(org_id: org_id, property: "Address")
      cv = ContactValue.where(contact: @contact, contact_property: @address_prop,).first_or_initialize
      cv.value = row[13]
      cv.save

      @club_prop = ContactProperty.find_or_create_by(org_id: org_id, property: "Club Team")
      cv = ContactValue.where(contact: @contact, contact_property: @club_prop,).first_or_initialize
      cv.value = row[14]
      cv.save

      @hs_prop = ContactProperty.find_or_create_by(org_id: org_id, property: "High School")
      cv = ContactValue.where(contact: @contact, contact_property: @hs_prop,).first_or_initialize
      cv.value = row[15]
      cv.save

      if row[16]
        @comments =  Note.create(contact: @contact, body: row[16])
      end

      last_contact_date = nil
      if row[4]
        last_contact_date = DateTime.parse(row[4])
        @last_contact_note = Note.create(contact: @contact, body: row[5], updated_at: last_contact_date)

        @last_contact_note.touch(time: last_contact_date)
        @contact.touch(time: last_contact_date)
      end

    end

    redirect_to contacts_path, notice: 'You successfully added contacts. Great job!'
  end


  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        @contact.touch
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def new_email
    # @contact = Contact.new

    @email = {}

    @email_templates = @active_org.email_templates

    @contacts = @active_org.contacts
    @contact_select_options = [['Select Contact', "0", {disabled: true, selected: true}]]

    @contacts.each do |contact|
      @contact_select_options << ["#{contact.first_name} #{contact.last_name}","#{contact.id}"]
    end

    @template_select_options = [['Blank Email', "0", {disabled: false, selected: true}]]

    @active_org.email_templates.each do |template|
      @template_select_options << ["#{template.name}","#{template.id}"]
    end

  end

  def new_email_with_list

    @email = {}

    @contacts = []

    ActiveSupport::JSON.decode(params[:contacts]).each do |c_id|
      @contacts << Contact.find(c_id)
    end

    @email_templates = @active_org.email_templates
    @template_select_options = [['Blank Email', "0", {disabled: false, selected: true}]]
    @active_org.email_templates.each do |template|
      @template_select_options << ["#{template.name}","#{template.id}"]
    end

    # respond_to do |format|
    #   format.html { render template: 'contacts/draft_list_email' }
    #   format.js {}
    #   format.json { head :no_content }
    # end
  end


  def send_email

    @contacts = @active_org.contacts

    @table_property_names = @active_org.contact_properties.ids

    @email_templates = @active_org.email_templates
    @template_select_options = [['Blank Email', "0", {disabled: false, selected: true}]]
    @active_org.email_templates.each do |template|
      @template_select_options << ["#{template.name}","#{template.id}"]
    end

    if email_params[:contact_id]
      @contact = Contact.find(email_params[:contact_id])
      @contact.send_email(email_params[:subject], email_params[:body], current_person)
      respond_to do |format|
        format.html { redirect_to @contact, notice: "You are keeping relationships alive! Email sent to #{@contact.email}."  }
        format.json { head :no_content }
      end
    elsif email_params[:contact_list]

      recipientsArr = []

      ActiveSupport::JSON.decode(email_params[:contact_list]).each do |contact_id|
        recipient = Contact.find(contact_id)

        if recipient.email.length > 0
          recipientsArr << recipient
          # recipient.send_email(email_params[:subject], email_params[:body], current_person)
        end
      end

      current_person.send_batch_email(recipientsArr, email_params[:subject], email_params[:body], current_person)

      redirect_to :contacts, notice: "You are keeping relationships alive! Email sent to #{email_params[:contact_list].length} contacts."

    else
      redirect_to :contacts, error: "You need to specify a specific contact or contacts to send an email."
    end


  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      # puts params[:contact_values_attributes].inspect
      # puts params.inspect

      params.require(:contact).permit(:first_name, :last_name, :phone, :email, :tag_list, :contact_values_attributes => [:id, :value, :date_value, :number_value, :contact_property_id])
    end

    def email_params
      params.permit(:contact_id, :subject, :body, :contact_list)
    end

    def batch_params
      params.permit(:file, :org_id)
    end
end
