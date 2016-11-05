require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  providers = RSpec.configuration.providers
  mapping_user

  def mock_omniauth(provider, data)
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(provider, data)
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[provider]
  end

  after do
    OmniAuth.config.test_mode = false
    providers.each do |provider|
      OmniAuth.config.mock_auth[provider] = nil
    end
    request.env["omniauth.auth"] = nil
  end

  providers.each do |provider|
    context "sign in with #{provider}" do
      before do
        @user = create :user, provider
        mock_omniauth provider, { uid: @user.authentications.first.uid, info: { email: @user.email } }
        get provider
      end

      it { expect(subject.current_user).to eq @user }
    end

    context "sign up with #{provider}" do
      before do
        mock_omniauth provider, { uid: 'uid12345', info: { email: 'mock@test.dev' } }
        get provider
      end

      it { expect(subject.current_user).not_to be_nil }
      it { expect(User.where(email: 'mock@test.dev').size).to be 1 }
      it { expect(User.find_by_email!('mock@test.dev').confirmed_at).not_to be nil }
    end

    context "bind #{provider} to existent user" do
      before do
        @user = create :user
        mock_omniauth provider, { uid: 'uid12345', info: { email: @user.email } }
        get provider
      end

      it { expect(response).to redirect_to new_user_session_path(oauth: true) }
      it { expect(session['oauth.data']).not_to be_nil }
      it { expect(session['oauth.data'][:info][:email]).to eq @user.email }
    end

    context "bind #{provider} to existent and logged in user" do
      before do
        @user = create :user
        sign_in @user
        mock_omniauth provider, { uid: 'uid12345', info: { email: @user.email } }
        get provider
      end

      it { expect(response).to redirect_to edit_user_registration_path(oauth: true) }
      it { expect(session['oauth.data']).not_to be_nil }
    end

    context "rerequest email on #{provider}" do
      before do
        @user = create :user
        sign_in @user
        mock_omniauth provider, { uid: 'uid12345', info: {} }
        get provider
      end

      it { expect(response).to redirect_to [:user, provider, :omniauth, :authorize, {auth_type: 'rerequest', scope: 'email'}] }
      it { expect(session['oauth.data']).to be_nil }
    end
  end
end
