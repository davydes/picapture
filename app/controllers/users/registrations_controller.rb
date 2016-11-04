class Users::RegistrationsController < Devise::RegistrationsController
  after_action :create_authentication, only: [:update], if: -> { oauth? && valid_password?}

  protected

  def valid_password?
    current_user.valid_password? params[:user][:current_password]
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
