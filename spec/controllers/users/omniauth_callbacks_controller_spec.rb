require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  def mock_omniauth(provider, data)
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(provider, data)
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[provider]
  end

  after do
    OmniAuth.config.test_mode = false
    OmniAuth.config.mock_auth[:facebook] = nil
    request.env["devise.mapping"] = nil
    request.env["omniauth.auth"] = nil
  end

  context 'sign in with facebook' do
    before do
      @user = create :user, :fb
      mock_omniauth :facebook, { uid: @user.authentications.first.uid, info: { email: @user.email } }
      get :facebook
    end

    it { expect(subject.current_user).to eq @user }
  end
end
