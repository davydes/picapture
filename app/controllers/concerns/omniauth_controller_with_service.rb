module OmniauthControllerWithService
  extend ActiveSupport::Concern

  included do
    helper_method :oauth?
  end

  def create_authentication
    service.create_authentication(current_user)
  end

  def oauth?
    params[:oauth] == 'true' && service.present?
  end

  def service
    @oauth_service ||= OauthService.new(session['oauth.data']) rescue nil
  end
end
