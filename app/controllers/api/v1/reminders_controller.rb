class Api::V1::RemindersController < Api::V1::BaseController
  include ActiveHashRelation

  def create
    @reminder = Reminder.new(reminder_params)
    @reminder.status = "incomplete"
    @reminder.creator_id = current_person.id

    if @reminder.save
      render json: @reminder, status: 201
    else
      format.json { render json: @reminder.errors, status: :unprocessable_entity }
    end
  end

  private

  def reminder_params
    params.require(:reminder).permit(:label, :next_date, :interval, :contact_id, :status, :assignee_id)
  end
end
