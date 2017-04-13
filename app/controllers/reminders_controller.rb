class RemindersController < ApplicationController
  before_action :authenticate_person!

  before_action :set_reminder, only: [:show, :edit, :update, :destroy]

  before_action :active_org

  layout "relate"

  # GET /reminders
  # GET /reminders.json
  def index
    @reminders = Reminder.all
  end

  # GET /reminders/1
  # GET /reminders/1.json
  def show
  end

  # GET /reminders/new
  def new
    @reminder = Reminder.new
    @contact = Contact.find(params[:contact])
    @contact_id = params[:contact]
  end

  # GET /reminders/1/edit
  def edit
    @contact = @reminder.contact
    @contact_id = @reminder.contact.id
  end

  # POST /reminders
  # POST /reminders.json
  def create
    @reminder = Reminder.new(reminder_params)
    @reminder.status = "incomplete"
    @blank_reminder = Reminder.new

    respond_to do |format|
      if @reminder.save
        format.html { redirect_to @reminder.contact, notice: 'Reminder was successfully created.' }
        format.js   {}
        format.json { render :show, status: :created, location: @reminder }
      else
        format.html { render :new }
        format.json { render json: @reminder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reminders/1
  # PATCH/PUT /reminders/1.json
  def update
    @contact = @reminder.contact

    if request.referer.present? && URI(request.referer).path == '/contacts'
      @contacts = @contact.org.contacts
      @reminders = Reminder.where(contact_id: @contacts.ids).order(:next_date)
      @truncate_length = 50
    else
      @reminders = @contact.reminders
      @truncate_length = 20
    end

    respond_to do |format|
      if @reminder.update(reminder_params)
        format.html { redirect_to @contact, notice: 'Reminder was successfully updated.' }
        format.js   {}
        format.json { render :show, status: :ok, location: @reminder }
      else
        format.html { render :edit }
        format.json { render json: @reminder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reminders/1
  # DELETE /reminders/1.json
  def destroy
    @contact = @reminder.contact
    @reminder.destroy
    respond_to do |format|
      format.html { redirect_to @contact, notice: 'Reminder was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reminder
      @reminder = Reminder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reminder_params
      params.require(:reminder).permit(:label, :next_date, :interval, :contact_id, :status)
    end
end
