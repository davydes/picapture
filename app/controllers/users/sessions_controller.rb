class Users::SessionsController < Devise::SessionsController
  include OmniauthControllerWithService

  before_action :setup_email,           only: [:new],    if: -> { bind_oauth? }
  after_action  :create_authentication, only: [:create], if: -> { bind_oauth? && valid_user? }

  protected

  def setup_email
    @email = service.binding_user.email
  end

  def valid_user?
    current_user == service.binding_user
  end
end
