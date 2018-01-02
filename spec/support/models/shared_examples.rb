# frozen_string_literal: true

RSpec.shared_examples 'creates new' do |model, count = 1|
  it "creates new #{model.model_name.name}" do
    expect {
      subject
    }.to change(model, :count).by(count)
  end
end

RSpec.shared_examples 'destroys' do |model, count = 1|
  it "destroys #{model.model_name.name}" do
    expect {
      subject
    }.to change(model, :count).by(-count)
  end
end

RSpec.shared_examples 'does not create new' do |model|
  it "does not create #{model.model_name.name}" do
    expect {
      subject
    }.not_to change(model, :count)
  end
end
