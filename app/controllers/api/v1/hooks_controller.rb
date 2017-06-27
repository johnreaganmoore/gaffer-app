class Api::V1::HooksController < Api::V1::BaseController
  include ActiveHashRelation

  def subscribe

    @hook = Hook.create(hook_params)

    if @hook.save
      render json: @hook, status: 201
      # format.json { render :show, status: :created, location: @contact }
    else
      render json: @hook.errors, status: :unprocessable_entity
    end

  end

  def unsubscribe
    @hook = Hook.find(params[:id])
    @hook.destroy
  end

  private
  def hook_params
    params.permit(:person_id, :target_url, :event)
  end
end
