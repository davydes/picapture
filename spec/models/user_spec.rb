require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    subject { build :user }
    it { expect(subject).to be_valid }
    it do
      subject.email = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages.keys).to eq [:email]
    end
  end

  context 'devise mailer' do
    before { @user = create :user }

    it do
      expect do
        @user.send_devise_notification(:password_change)
      end.to have_enqueued_job.on_queue('mailers')
    end
  end

  context 'members' do
    it { expect(subject).to respond_to :authentications }
    it { expect(subject).to respond_to :send_devise_notification}
  end
end
