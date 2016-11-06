require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  providers = RSpec.configuration.providers
  mapping_user

  providers.each do |provider|
    context "create authentication #{provider}" do
      before do
        @auth_uid = 'non_exists_uid123'
        @user = create :user, *providers, password: 'testpassword'
        @auths = Authentication.where(user: @user, provider: provider)
        session['oauth.data'] = {
          provider: provider,
          uid: @auth_uid,
          info: { email: @user.email }
        }
      end

      context 'GET /users/sign_in' do
        before { get :new, params: { oauth: true } }

        it { expect(subject.bind_oauth?).to be true }
        it { expect(assigns(:email)).to eq(@user.email) }
        it { expect(response).to render_template 'devise/sessions/new' }
        it { expect(response.status).to be 200 }
      end

      context 'POST /users/sign_in (with right password)' do
        before do
          put :create, params: {
            oauth: true,
            user: {
              email: @user.email,
              password: @user.password
            }
          }
        end

        it { expect(subject.bind_oauth?).to be true }
        it { expect(response).not_to render_template 'devise/sessions/new' }
        it { expect(@auths.exists?(uid: @auth_uid)).to be true }
      end

      context 'POST /users/sign_in (without password)' do
        before { put :create, params: { oauth: true }, user: { email: @user.email } }

        it { expect(subject.bind_oauth?).to be true }
        it { expect(response).to render_template 'devise/sessions/new' }
        it { expect(@auths.exists?(uid: @auth_uid)).not_to be true }
      end
    end
  end
end
