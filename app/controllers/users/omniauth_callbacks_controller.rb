class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def callback
    if user_signed_in? || service.need_to_bind?
      session['devise.auth_data'] = auth_data
      redirect_to new_user_authentication_path
    else
      user = service.find_or_create_user
      sign_in_and_redirect user, event: :authentication
    end
  end

  alias_method :vkontakte,     :callback
  alias_method :google_oauth2, :callback

  # In the new Facebook login dialog the user can decline to provide email address.
  def facebook
    if auth_data.info.email.blank?
      return redirect_to "/users/auth/facebook?auth_type=rerequest&scope=email"
    end
    callback
  end

  private

  def auth_data
    @auth_data ||= request.env['omniauth.auth'].except(:extra)
  end

  def service
    @service ||= OauthService.new(auth_data)
  end
end
