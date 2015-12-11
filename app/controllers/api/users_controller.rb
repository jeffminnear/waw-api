class Api::UsersController < ApiController
  before_action :authenticated?

  def index
    users = User.all

    render json: users.to_json
  end
end
