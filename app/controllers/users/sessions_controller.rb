class Users::SessionsController < Devise::SessionsController
  before_action :setup_email,           only: [:new],    if: -> { oauth? }
  after_action  :create_authentication, only: [:create], if: -> { oauth? && valid_user? }

  protected

  def setup_email
    @email = service.binding_user.email
  end

  def valid_user?
    current_user == service.binding_user
  end

  def create_authentication
    service.create_authentication(current_user)
  end

  def oauth?
    params[:oauth] == 'true' && service.present?
  end
  helper_method :oauth?

  def service
    @oauth_service ||= OauthService.new(session['oauth.data']) rescue nil
  end
end
