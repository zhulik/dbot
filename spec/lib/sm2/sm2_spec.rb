# frozen_string_literal: true

describe SM2::SM2 do
  around do |example|
    Timecop.freeze('10.01.2018 13:00') do
      example.run
    end
  end

  describe 'calculated results' do
    context 'when user starts learning new element' do
      it 'has valid values' do
        sm2 = described_class.new(5)
        expect(sm2.interval).to eq(1)
        expect(sm2.next_repetition_date).to eq(Date.tomorrow)
        expect(sm2.easiness_factor).to eq(2.6)

        sm2 = described_class.new(4)
        expect(sm2.interval).to eq(1)
        expect(sm2.next_repetition_date).to eq(Date.tomorrow)
        expect(sm2.easiness_factor).to eq(2.5)

        sm2 = described_class.new(3)
        expect(sm2.interval).to eq(1)
        expect(sm2.next_repetition_date).to eq(Date.tomorrow)
        expect(sm2.easiness_factor).to eq(2.36)
      end
    end

    context 'when user is doing good' do
      it 'has valid values' do
        sm2 = described_class.new(4, 6, 2.1)
        expect(sm2.interval).to eq(12)
        expect(sm2.next_repetition_date).to eq('22.01.2018'.to_date)
        expect(sm2.easiness_factor).to eq(2.1)

        sm2 = described_class.new(5, 12, 2.1)
        expect(sm2.interval).to eq(25)
        expect(sm2.next_repetition_date).to eq('04.02.2018'.to_date)
        expect(sm2.easiness_factor).to eq(2.2)

        sm2 = described_class.new(5, 25, 2.1)
        expect(sm2.interval).to eq(52)
        expect(sm2.next_repetition_date).to eq('03.03.2018'.to_date)
        expect(sm2.easiness_factor).to eq(2.2)
      end
    end

    context 'when user is doing good but later is going bad' do
      it 'has valid values' do
        sm2 = described_class.new(3, 6, 2.1)
        expect(sm2.interval).to eq(12)
        expect(sm2.next_repetition_date).to eq('22.01.2018'.to_date)
        expect(sm2.easiness_factor).to eq(1.96)

        sm2 = described_class.new(0, 12, 1.96)
        expect(sm2.interval).to eq(0)
        expect(sm2.next_repetition_date).to eq(Date.today)
        expect(sm2.easiness_factor).to eq(1.96)

        sm2 = described_class.new(0, 1, 1.96)
        expect(sm2.interval).to eq(0)
        expect(sm2.next_repetition_date).to eq(Date.today)
        expect(sm2.easiness_factor).to eq(1.96)

        sm2 = described_class.new(4, 0, 1)
        expect(sm2.interval).to eq(1)
        expect(sm2.next_repetition_date).to eq(Date.tomorrow)
        expect(sm2.easiness_factor).to eq(1.3)
      end
    end
  end
end
