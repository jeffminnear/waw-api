class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  private

  def authenticated?
    authenticate_or_request_with_http_basic do |email, password|
      user = User.find_for_database_authentication(email: email)
      user && user.valid_for_authentication? { user.valid_password?(password) }
    end
  end
end
