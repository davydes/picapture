require 'rails_helper'

RSpec.describe Authentication, type: :model do
  context 'validations' do
    subject { build :authentication, :fb }
    it { expect(subject).to be_valid }
  end
end
