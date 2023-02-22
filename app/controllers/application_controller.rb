class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :autenticate!

  private

  def autenticate!
    authenticate_or_request_with_http_token do |token, _options|
      payload = JwtAuth::TokenProvider.decode_token(token)
      @current_user = User.find_by(email: payload['email'])
    rescue ExceptionHandler::InvalidToken
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end
end
