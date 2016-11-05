class Users::RegistrationsController < Devise::RegistrationsController
  include OmniauthControllerWithService

  after_action :create_authentication, only: [:update], if: -> { bind_oauth? && valid_password? }

  protected

  def valid_password?
    current_user.valid_password? params[:user].try(:[], :current_password)
  end
end
