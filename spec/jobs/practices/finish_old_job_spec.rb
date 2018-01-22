# frozen_string_literal: true

describe Practices::FinishOldJob do
  let(:user) { create :user }
  let!(:practice_stat) { create :practice_stat, user: user, updated_at: Time.zone.now - 10.minutes }
  let(:job) { described_class.new }

  describe '#perform' do
    subject { job.perform }

    it 'finishes old practices' do
      subject
      expect(practice_stat.reload).to be_finished
    end
  end
end
