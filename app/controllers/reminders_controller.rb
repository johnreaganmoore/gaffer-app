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

    available_admins = @active_org.admins
    # available_admins.delete(current_person)

    # @admins_options = [
    #   ["#{current_person.first_name} #{current_person.last_name}", current_person.id, {disabled: false, selected: true}],
    # ]
    @admins_options = []

    available_admins.each do |admin|
      @admins_options << ["#{admin.first_name} #{admin.last_name}", admin.id]
    end

    puts @admins_options

    if params[:contact]
      @contact = Contact.find(params[:contact])
      @contact_id = params[:contact]
    else
      @contacts = @active_org.contacts

      @contact_select_options = [['Select Contact', "0", {disabled: true, selected: true}]]

      @contacts.each do |contact|
        @contact_select_options << ["#{contact.first_name} #{contact.last_name}","#{contact.id}"]
      end

    end

  end

  # GET /reminders/1/edit
  def edit
    @contact = @reminder.contact
    @contact_id = @reminder.contact.id

    available_admins = @active_org.admins

    @admins_options = []

    available_admins.each do |admin|
      @admins_options << ["#{admin.first_name} #{admin.last_name}", admin.id]
    end

  end

  # POST /reminders
  # POST /reminders.json
  def create
    @reminder = Reminder.new(reminder_params)
    @reminder.status = "incomplete"
    @reminder.creator_id = current_person.id
    @blank_reminder = Reminder.new

    available_admins = @active_org.admins

    @admins_options = []

    available_admins.each do |admin|
      @admins_options << ["#{admin.first_name} #{admin.last_name}", admin.id]
    end

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
    @contacts = @active_org.contacts

    @current_person_tasks = Reminder.where(assignee_id: current_person.id).where.not(status: "archived").order(:next_date)
    @unassigned_tasks = Reminder.where(contact_id: @contacts.ids).where.not(status: "archived").where(assignee_id: nil).order(:next_date)



    if request.referer.present? && URI(request.referer).path == '/contacts'
      @reminders = Reminder.where(assignee_id: current_person.id).where.not(status: "archived").order(:next_date)
      @current_person_tasks = Reminder.where(assignee_id: current_person.id).where.not(status: "archived").order(:next_date)
      @unassigned_tasks = Reminder.where(contact_id: @contacts.ids).where.not(status: "archived").where(assignee_id: nil).order(:next_date)

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
      params.require(:reminder).permit(:label, :next_date, :interval, :contact_id, :status, :assignee_id)
    end
end
