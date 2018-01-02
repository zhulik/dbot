# frozen_string_literal: true

describe Language do
  describe 'valid?' do
    context 'with invalid language code' do
      let(:language) { build :language, code: 'zz' }
      subject { language.valid? }

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end
  end

  describe '#full_code' do
    let(:language) { build :language, code: 'de' }
    subject { language.full_code }

    it 'it returns valid full code' do
      expect(subject).to eq('deu')
    end
  end
end
