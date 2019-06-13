class ApplicationController < ActionController::API
  include Pundit
  @teste = :teste
  protected

  def system
    "comercial"
  end

  def decoded_token_test
    secret = Digest::SHA256.hexdigest 'provider_app'
    decoded_token = JWT.decode params[:token], secret, true, { algorithm: 'HS512' }
  end
end
