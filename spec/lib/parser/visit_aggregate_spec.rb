# frozen_string_literal: true

require 'parser/visit_aggregate'

describe Parser::VisitAggregate do
  let(:visit_aggregate) { Parser::VisitAggregate.new }
  let(:page) { '/test/1' }
  let(:page1) { '/test/' }
  let(:ip) { '1.1.1.1' }
  let(:ip1) { '1.1.1.2' }

  describe '#initialize' do
    it 'initialize hash for visits' do
      expect(visit_aggregate.visits).to eq({})
    end
  end

  describe '#add' do
    it 'adds entry in visits' do
      visit_aggregate.add(page, ip)

      expect(visit_aggregate.visits[page]).to be_truthy
    end

    it 'adds multiple entries in visits' do
      visit_aggregate.add(page, ip)
      visit_aggregate.add(page1, ip1)

      expect(visit_aggregate.visits[page]).to be_truthy
      expect(visit_aggregate.visits[page1]).to be_truthy
    end

    it 'adds multiple entries for the same page' do
      visit_aggregate.add(page, ip)
      visit_aggregate.add(page, ip1)

      expect(visit_aggregate.visits[page]).to be_truthy
      expect(visit_aggregate.visits[page].count).to eq(2)
      expect(visit_aggregate.visits[page].ips).to eq([ip, ip1])
    end

    it 'adds multiple entries for the same ip' do
      visit_aggregate.add(page, ip)
      visit_aggregate.add(page, ip)

      expect(visit_aggregate.visits[page]).to be_truthy
      expect(visit_aggregate.visits[page].count).to eq(2)
      expect(visit_aggregate.visits[page].ips).to eq([ip])
    end
  end

  describe '#result' do
    it 'returns result in hash form in order' do
      visit_aggregate.add(page1, ip)
      visit_aggregate.add(page, ip)
      visit_aggregate.add(page, ip)

      expect(visit_aggregate.result).to eq({ page => 2, page1 => 1 })
    end

    it 'returns unique result in hash form in order' do
      visit_aggregate.add(page, ip)
      visit_aggregate.add(page, ip)
      visit_aggregate.add(page1, ip)
      visit_aggregate.add(page1, ip1)

      expect(visit_aggregate.result(unique: true)).to eq({ page1 => 2, page => 1 })
    end
  end
end
