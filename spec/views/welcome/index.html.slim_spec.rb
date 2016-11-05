require 'rails_helper'

RSpec.describe 'welcome/index', type: :view do
  before { render }
  it { expect(rendered).to match('Welcome') }
end
