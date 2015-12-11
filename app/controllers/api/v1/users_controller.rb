class Api::UsersController < ApiController
  before_action :authenticated?

  def index
  end
end
