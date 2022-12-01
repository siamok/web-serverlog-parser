# frozen_string_literal: true

require 'parser/log_parser'

describe Parser::LogParser do
  describe '#parse' do
    let(:input_file) { 'test.log' }
    let(:options) { { paths: [input_file], output: nil, unique: unique } }
    let(:unique) { false }
    let(:page) { '/test/1' }
    let(:page1) { '/test/' }
    let(:ip) { '1.1.1.1' }
    let(:ip1) { '1.1.1.2' }

    before do
      allow(File).to receive(:foreach).with(input_file)
                                      .and_yield("#{page} #{ip}\n")
                                      .and_yield("#{page} #{ip1}\n")
                                      .and_yield("#{page1} #{ip}\n")
                                      .and_yield("#{page1} #{ip}")
    end

    it 'returns results in order' do
      result = Parser::LogParser.new(options).parse

      expect(result).to eq({ page => 2, page1 => 2})
    end

    it 'returns unique results in order' do
      result = Parser::LogParser.new(options).parse

      expect(result).to eq({ page => 2, page1 => 1})
    end
  end
end
