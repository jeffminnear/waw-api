class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token


  private

  def authenticated?
    authenticate_or_request_with_http_basic {|email, encrypted_password| User.where( email: email, encrypted_password: encrypted_password).present? }
  end
end
