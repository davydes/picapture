class Users::SessionsController < Devise::SessionsController
  include OmniauthControllerWithService

  before_action :setup_email,           only: [:new],    if: -> { oauth? }
  after_action  :create_authentication, only: [:create], if: -> { oauth? && valid_user? }

  protected

  def setup_email
    @email = service.binding_user.email
  end

  def valid_user?
    current_user == service.binding_user
  end
end
