class TokensController < ApplicationController
  before_action :setup_token_mode
  before_action :authenticate_user!
  skip_before_action :redirect_to_token

  def token
    redirect_to "/blank.html?token=#{current_user.api_token}"
  end

  protected

  def setup_token_mode
    cookies[:token_mode] ||= true
  end
end
