# frozen_string_literal: true

RSpec.shared_examples 'has response and returns' do |status, data|
  it "has #{status} response" do
    subject
    if status.is_a?(Integer)
      expect(response.status).to eq(status)
    else
      expect(response).to send("be_#{status}")
    end
  end

  it 'returns valid data' do
    subject
    expected = instance_eval(&data)
    if expected.is_a?(Array)
      expect(response.parsed_body).to match_array(expected)
    else
      expect(response.parsed_body).to eq(expected)
    end
  end
end
