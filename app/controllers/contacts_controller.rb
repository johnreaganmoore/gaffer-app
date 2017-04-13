class ContactsController < ApplicationController
  before_action :authenticate_person!
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_action :active_org

  layout "relate"

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = @active_org.contacts

      # @filterrific = initialize_filterrific(
      #   Contact,
      #   params[:filterrific],
      #   :select_options => {
      #     sorted_by: Contact.options_for_sorted_by,
      #   }
      # ) or return
      # @contacts = @filterrific.find #.page(params[:page])

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

        puts @contact.tag_list.inspect

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
      params.require(:contact).permit(:first_name, :last_name, :phone, :email, :tag_list)
    end

    def email_params
      params.permit(:contact_id, :subject, :body)
    end
end
