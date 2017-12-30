# frozen_string_literal: true

RSpec.shared_examples 'returns' do |value|
  it "returns #{value}" do
    expect(subject).to eq(value)
  end
end

RSpec.shared_examples 'raises' do |exception, message|
  it "raises #{exception} with message=#{message}" do
    expect { subject }.to raise_error(exception, message)
  end
end
