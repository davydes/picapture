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

  context 'members' do
    it { expect(subject).to respond_to :authentications }
    it { expect(subject).to respond_to :send_devise_notification}
  end
end
