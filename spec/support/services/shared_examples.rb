# frozen_string_literal: true

RSpec.shared_examples 'returns failure' do |type, text|
  it "returns failure with type #{type}" do
    expect(subject.failure.type).to eq(type)
  end

  if text.present?
    it "returns failure with data == '#{text}'" do
      expect(subject.failure.data).to eq(text)
    end
  end
end

RSpec.shared_examples 'returns success' do |data = nil|
  it 'returns success' do
    expect(subject).to be_success
  end

  unless data.nil?
    it 'returns valid output' do
      expect(subject.output).to eq(instance_eval(&data))
    end
  end
end
