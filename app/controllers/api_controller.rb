class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  private

  def authenticate_user!
    authenticate_or_request_with_http_basic do |email, password|
      user = User.find_for_database_authentication(email: email)
      authenticated = user && user.valid_for_authentication? { user.valid_password?(password) }
      @current_user = user if authenticated
      authenticated
    end
  end
end
