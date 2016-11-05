require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  providers = RSpec.configuration.providers
  mapping_user

  providers.each do |provider|
    context "create authentication #{provider}" do
      before do
        @auth_uid = 'non_exists_uid123'
        @user = create :user, *providers, password: 'testpassword'
        @auths = Authentication.where(user: @user, provider: provider)

        sign_in @user
        session['oauth.data'] = {
          provider: provider,
          uid: @auth_uid,
          info: {
            email: 'some@email.dev',
          }
        }
      end

      context 'GET /users/edit' do
        before { get :edit, params: { oauth: true } }

        it { expect(subject.bind_oauth?).to be true }
        it { expect(response).to render_template 'devise/registrations/edit' }
        it { expect(response.status).to be 200 }
      end

      context 'PUT /users (with right password)' do
        before do
          put :update, params: {
            oauth: true,
            user: { current_password: @user.password }
          }
        end

        it { expect(subject.bind_oauth?).to be true }
        it { expect(response).not_to render_template 'devise/registrations/edit' }
        it { expect(@auths.exists?(uid: @auth_uid)).to be true }
      end

      context 'PUT /users (without password)' do
        before { put :update, params: { oauth: true } }

        it { expect(subject.bind_oauth?).to be true }
        it { expect(response).to render_template 'devise/registrations/edit' }
        it { expect(@auths.exists?(uid: @auth_uid)).not_to be true }
      end
    end
  end
end
