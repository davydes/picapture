class Users::AuthenticationsController < ApplicationController
  before_action :params_verify!

  def new
  end

  def create
    if user.valid_password?(params[:user][:password])
      service.create_authentication(user)
      session.delete('devise.auth_data')
      flash[:notice] = I18n.t("#{translation_scope}.successfully_created")
      redirect_to :root
    else
      flash[:alert] = I18n.t("#{translation_scope}.password_incorrect")
      render :new
    end
  end

  private

  def params_verify!
    if (service.nil? || user.nil?)
      redirect_to :root
    end
  end

  def service
    return nil if session['devise.auth_data'].nil?
    @service ||= OauthService.new(session['devise.auth_data'])
  end

  def user
    @user ||= (current_user || service.binding_user)
  end
  helper_method :user

  def translation_scope
    'users.authentications'
  end
end
