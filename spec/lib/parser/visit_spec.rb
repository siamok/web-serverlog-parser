require 'parser/visit'

describe Parser::Visit do
  let(:visit) { Parser::Visit.new }
  let(:ip) { '1.1.1.1'}
  let(:ip1) { '1.1.1.2'}

  describe '#initialize' do
    it 'initialize with reset values' do
      expect(visit.count).to eq(0)
      expect(visit.ips).to eq([])
    end
  end

  describe '#add' do
    it 'increases count' do
      visit.add(ip)

      expect(visit.count).to eq(1)
    end

    it 'adds ip to unique valus' do
      visit.add(ip)

      expect(visit.ips).to eq([ip])
    end

    context 'multiple adds' do
      it 'counts multiple adds' do
        visit.add(ip)
        visit.add(ip1)
  
        expect(visit.count).to eq(2)
        expect(visit.ips).to eq([ip, ip1])
      end

      it 'counts unique ids' do
        visit.add(ip)
        visit.add(ip)

        expect(visit.count).to eq(2)
        expect(visit.ips).to eq([ip])
      end
    end
  end
end
