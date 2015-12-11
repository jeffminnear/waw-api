class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token


  private

  def authenticated?
    authenticate_or_request_with_http_basic {|email, password| User.where( email: email, password: password).present? }
  end
end
