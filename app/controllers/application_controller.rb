class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include JsonapiSuite::ControllerMixin

  register_exception Errors::NotAuthenticated, status: 401
  register_exception Errors::NotAuthorized, status: 403
  register_exception ActiveRecord::RecordNotFound, status: 404

  before_action :authenticate_user!

  rescue_from Exception do |e|
    handle_exception(e, show_raw_error: true)
  end

  def current_user
    @current_user
  end

  protected

  def authenticate_user!
    @current_user ||= user_via_jwt
  end

  def user_via_jwt
    user = User.find_by(id: decoded_jwt[0]['data']['id'])
    unauthenticated! unless user
    user
  end

  def decoded_jwt
    begin
      secret = Shepherd::Application.secrets[:secret_key_base]
      JWT.decode(jwt, secret, true, { :algorithm => 'HS256' })
    rescue JWT::DecodeError
      unauthenticated!
    end
  end

  def jwt
    header = request.headers['Authorization']
    unauthenticated! unless header && header.include?('Token token="')
    header.split('Token token="')[1].split('"')[0]
  end

  def unauthenticated!
    raise Errors::NotAuthenticated, 'Access is denied due to invalid token.'
  end
end
