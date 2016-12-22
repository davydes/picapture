require 'rails_helper'

RSpec.describe Api::PhotosController, type: :controller do
  before { request.env['HTTP_ACCEPT'] = 'application/json' }

  context 'GET index' do
    subject { get :index }

    context 'when requested' do
      before { subject }

      it { expect(response.status).to be 200 }
      it { expect(JSON.parse response.body).to be_a Array }
    end
  end
end
