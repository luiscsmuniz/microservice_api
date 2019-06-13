class ApplicationController < ActionController::API
  include Pundit

  protected

  def system
    "comercial"
  end

  def decoded_token
    decoded_token = JWT.decode request.headers['Authorization'], self.secret_key_jwt, true, { algorithm: 'HS512' }
  end

  def secret_key_jwt
    secret = Digest::SHA256.hexdigest 'provider_app'
  end
end
