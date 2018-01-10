# frozen_string_literal: true

describe SM2::SM2 do
  let(:algo) { described_class.new(quality, prev_interval, prev_ef) }

  around do |example|
    Timecop.freeze('10.01.2018 13:00') do
      example.run
    end
  end

  describe 'calculated results' do
    context 'with 0 quality' do
      let(:quality) { 0 }
      let(:prev_interval) { 0 }
      let(:prev_ef) { 2.5 }

      it 'returns valid results' do
        expect(algo.next_repetition_date).to eq(Date.today)
        expect(algo.interval).to eq(0)
        expect(algo.easiness_factor).to eq(2.5)
      end
    end

    context 'with 1 quality' do
      let(:quality) { 1 }
      let(:prev_interval) { 0 }
      let(:prev_ef) { 2.5 }

      it 'returns valid results' do
        expect(algo.next_repetition_date).to eq(Date.today)
        expect(algo.interval).to eq(0)
        expect(algo.easiness_factor).to eq(2.5)
      end
    end

    context 'with 2 quality' do
      let(:quality) { 2 }

      context 'with 0 prev interval' do
        let(:prev_interval) { 0 }
        let(:prev_ef) { 2.5 }

        it 'returns valid results' do
          expect(algo.next_repetition_date).to eq(Date.tomorrow)
          expect(algo.interval).to eq(1)
          expect(algo.easiness_factor).to eq(2.5)
        end
      end

      context 'with 1 prev interval' do
        let(:prev_interval) { 1 }
        let(:prev_ef) { 2.5 }

        it 'returns valid results' do
          expect(algo.next_repetition_date).to eq('Tue, 16 Jan 2018'.to_date)
          expect(algo.interval).to eq(6)
          expect(algo.easiness_factor).to eq(2.5)
        end
      end

      context 'with 10 prev interval' do
        let(:prev_interval) { 10 }
        let(:prev_ef) { 2.5 }

        it 'returns valid results' do
          expect(algo.next_repetition_date).to eq('Sun, 04 Feb 2018'.to_date)
          expect(algo.interval).to eq(25)
          expect(algo.easiness_factor).to eq(2.5)
        end
      end
    end

    context 'with 3 quality' do
      let(:quality) { 3 }

      context 'with 0 prev interval' do
        let(:prev_interval) { 0 }
        let(:prev_ef) { 2.5 }

        it 'returns valid results' do
          expect(algo.next_repetition_date).to eq('Tue, 16 Jan 2018'.to_date)
          expect(algo.interval).to eq(6)
          expect(algo.easiness_factor).to eq(2.6)
        end
      end

      context 'with 1 prev interval' do
        let(:prev_interval) { 1 }
        let(:prev_ef) { 2.5 }

        it 'returns valid results' do
          expect(algo.next_repetition_date).to eq('Tue, 16 Jan 2018'.to_date)
          expect(algo.interval).to eq(6)
          expect(algo.easiness_factor).to eq(2.6)
        end
      end

      context 'with 10 prev interval' do
        let(:prev_interval) { 10 }
        let(:prev_ef) { 2.5 }

        it 'returns valid results' do
          expect(algo.next_repetition_date).to eq('Sun, 04 Feb 2018'.to_date)
          expect(algo.interval).to eq(25)
          expect(algo.easiness_factor).to eq(2.6)
        end
      end
    end

    context 'with 4 quality' do
      let(:quality) { 3 }

      context 'with 0 prev interval' do
        let(:prev_interval) { 0 }
        let(:prev_ef) { 2.5 }

        it 'returns valid results' do
          expect(algo.next_repetition_date).to eq('Tue, 16 Jan 2018'.to_date)
          expect(algo.interval).to eq(6)
          expect(algo.easiness_factor).to eq(2.6)
        end
      end

      context 'with 1 prev interval' do
        let(:prev_interval) { 1 }
        let(:prev_ef) { 2.5 }

        it 'returns valid results' do
          expect(algo.next_repetition_date).to eq('Tue, 16 Jan 2018'.to_date)
          expect(algo.interval).to eq(6)
          expect(algo.easiness_factor).to eq(2.6)
        end
      end

      context 'with 10 prev interval' do
        let(:prev_interval) { 10 }
        let(:prev_ef) { 2.5 }

        it 'returns valid results' do
          expect(algo.next_repetition_date).to eq('Sun, 04 Feb 2018'.to_date)
          expect(algo.interval).to eq(25)
          expect(algo.easiness_factor).to eq(2.6)
        end
      end
    end
  end
end
