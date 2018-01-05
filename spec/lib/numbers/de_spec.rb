# frozen_string_literal: true

describe Numbers::De do
  describe '.words' do
    it { expect(described_class.words(0)).to eq('null') }
    it { expect(described_class.words(1)).to eq('eins') }
    it { expect(described_class.words(4)).to eq('vier') }
    it { expect(described_class.words(11)).to eq('elf') }
    it { expect(described_class.words(12)).to eq('zwölf') }
    it { expect(described_class.words(17)).to eq('siebzehn') }
    it { expect(described_class.words(30)).to eq('dreißig') }
    it { expect(described_class.words(41)).to eq('einundvierzig') }
    it { expect(described_class.words(99)).to eq('neunundneunzig') }
    it { expect(described_class.words(101)).to eq('einhunderteins') }
    it { expect(described_class.words(111)).to eq('einhundertelf') }
    it { expect(described_class.words(112)).to eq('einhundertzwölf') }
    it { expect(described_class.words(117)).to eq('einhundertsiebzehn') }
    it { expect(described_class.words(133)).to eq('einhundertdreiunddreißig') }
    it { expect(described_class.words(300)).to eq('dreihundert') }
    it { expect(described_class.words(843)).to eq('achthundertdreiundvierzig') }
    it { expect(described_class.words(801)).to eq('achthunderteins') }
    it { expect(described_class.words(810)).to eq('achthundertzehn') }
    it { expect(described_class.words(999)).to eq('neunhundertneunundneunzig') }
    it { expect(described_class.words(1000)).to eq('tausend') }
    it { expect(described_class.words(2010)).to eq('zweitausendzehn') }
    it { expect(described_class.words(2100)).to eq('zweitausendeinhundert') }
    it { expect(described_class.words(2300)).to eq('zweitausenddreihundert') }
    it { expect(described_class.words(2213)).to eq('zweitausendzweihundertdreizehn') }
    it { expect(described_class.words(2254)).to eq('zweitausendzweihundertvierundfünfzig') } # my eyes!
    it { expect(described_class.words(10_000)).to eq('zehntausend') }
    it { expect(described_class.words(10_100)).to eq('zehntausendeinhundert') }
    it { expect(described_class.words(12_100)).to eq('zwölftausendeinhundert') }
    it { expect(described_class.words(20_100)).to eq('zwanzigtausendeinhundert') }
    it { expect(described_class.words(20_200)).to eq('zwanzigtausendzweihundert') }
    it { expect(described_class.words(543_481)).to eq('fünfhundertdreiundvierzigtausendvierhunderteinundachtzig') } # my fucking eyes!!!
  end
end
