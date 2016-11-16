require 'spec_helper'

describe 'resolve_dependencies' do
  let(:apps) do
    ['winzip']
  end
  it { is_expected.to run.with_params(apps).and_return('some_value') }
end
