class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def callback
    # Пользователь может запретить передачу email, отправляем повторный запрос
    if auth_data.info.email.blank?
      return redirect_to [:user, auth_data.provider.to_sym, :omniauth, :authorize, {auth_type: 'rerequest', scope: 'email'}]
    end

    if user_signed_in?
      # Когда пользователь залогинен, привяжем к нему, через
      # devise контроллер изменения учетных данных
      bind_via_registrations_edit
    elsif service.need_to_bind?
      # Когда пользователь не залогинен, но матчим емейл
      # в базе, просим его войти, потом привязываем
      bind_via_sessions_new
    else
      # Пользователь был раннее приязан или
      # вообще новый пользователь, регаем его немедля!
      user = service.find_or_create_user
      sign_in_and_redirect user, event: :authentication
    end
  end

  alias_method :google_oauth2, :callback
  alias_method :facebook,      :callback
  alias_method :vkontakte,     :callback

  private

  def bind_via_registrations_edit
    session['oauth.data'] = auth_data
    set_flash_message!(:notice, :need_password_to_bind)
    redirect_to edit_user_registration_path(oauth: true)
  end

  def bind_via_sessions_new
    session['oauth.data'] = auth_data
    set_flash_message!(:notice, :need_password_to_bind)
    redirect_to new_user_session_path(oauth: true)
  end

  def auth_data
    @auth_data ||= request.env['omniauth.auth'].except(:extra)
  end

  def service
    @oauth_service ||= OauthService.new(auth_data) rescue nil
  end
end
