class Api::V1::SessionsController < Api::V1::BaseController
  def create
    user = Person.find_by(email: create_params[:email])
    if person && person.authenticate(create_params[:password])
      self.current_user = user
      render(
        json: Api::V1::SessionSerializer.new(person, root: false).to_json,
        status: 201
      )
    else
      return api_error(status: 401)
    end
  end

  private
  def create_params
    params.require(:user).permit(:email, :password)
  end
end
