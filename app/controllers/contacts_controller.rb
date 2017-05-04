class ContactsController < ApplicationController
  before_action :authenticate_person!
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_action :active_org

  layout "relate"

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = @active_org.contacts
    @contact_list = @contacts.map do |c|

      if c.next_reminder != nil && c.next_reminder < Date.today
        next_date = nil
      else
        next_date = c.next_reminder
      end

      c_tags = c.tags.map {|tag| tag.name }

      {
        id: c.id,
        first_name: c.first_name,
        last_name: c.last_name,
        tags: c_tags,
        next_reminder: next_date,
        latest_activity: c.latest_activity
      }
    end
    @js_contacts = @contact_list.to_json

    @tasks = Reminder.where(contact_id: @contacts.ids).order(:next_date)

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

  def send_email
    @contact = Contact.find(email_params[:contact_id])
    @contact.send_email(email_params[:subject], email_params[:body], current_person)

    respond_to do |format|
      format.html { redirect_to @contact, notice: "Email sent to #{@contact.email}"  }
      format.json { head :no_content }
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:first_name, :last_name, :phone, :email, :tag_list, :contact_values_attributes => [:id, :value, :contact_property_id])
    end

    def email_params
      params.permit(:contact_id, :subject, :body)
    end
end
