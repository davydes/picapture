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

  context 'sign up with facebook' do
    before do
      mock_omniauth :facebook, { uid: 'uid12345', info: { email: 'mock@test.dev' } }
      get :facebook
    end

    it { expect(subject.current_user).not_to be_nil }
    it { expect(User.where(email: 'mock@test.dev').size).to be 1 }
    it { expect(User.find_by_email!('mock@test.dev').confirmed_at).not_to be nil }
  end

  context 'bind facebook to existent user' do
    before do
      @user = create :user
      mock_omniauth :facebook, { uid: 'uid12345', info: { email: @user.email } }
      get :facebook
    end

    it { expect(response).to redirect_to new_user_session_path(oauth: true) }
    it { expect(session['oauth.data']).not_to be_nil }
    it { expect(session['oauth.data'][:info][:email]).to eq @user.email }
  end

  context 'bind facebook to existent and logged in user' do
    before do
      @user = create :user
      sign_in @user
      mock_omniauth :facebook, { uid: 'uid12345', info: { email: @user.email } }
      get :facebook
    end

    it { expect(response).to redirect_to edit_user_registration_path(oauth: true) }
    it { expect(session['oauth.data']).not_to be_nil }
  end
end
