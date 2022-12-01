# frozen_string_literal: true

require 'parser/log_parser'

describe Parser::LogParser do
  describe '#parse' do
    let(:input_file) { 'test.log' }
    let(:input_file1) { 'test1.log' }
    let(:options) { { paths: [input_file], output: nil, unique: false } }
    let(:options_multiple_paths) { { paths: [input_file, input_file1], output: nil, unique: false } }

    let(:page) { '/test' }
    let(:page1) { '/test/1' }
    let(:page2) { '/test/2' }
    let(:ip) { '1.1.1.1' }
    let(:ip1) { '1.1.1.2' }
    let(:ip2) { '1.1.1.3' }

    before do
      allow(File).to receive(:foreach).with(input_file)
                                      .and_yield("#{page} #{ip}\n")
                                      .and_yield("#{page} #{ip1}\n")
                                      .and_yield("#{page1} #{ip}\n")
                                      .and_yield("#{page1} #{ip}")

      allow(File).to receive(:foreach).with(input_file1)
                                      .and_yield("#{page1} #{ip1}\n")
                                      .and_yield("#{page1} #{ip2}\n")
                                      .and_yield("#{page2} #{ip}\n")
    end

    it 'returns results in order' do
      result = Parser::LogParser.new(options).parse

      expect(result).to eq({ page => 2, page1 => 2 })
    end

    it 'returns unique results in order' do
      options[:unique] = true
      result = Parser::LogParser.new(options).parse

      expect(result).to eq({ page => 2, page1 => 1 })
    end

    it 'returns results in order for multiple files' do
      result = Parser::LogParser.new(options_multiple_paths).parse

      expect(result).to eq({ page1 => 4, page => 2, page2 => 1 })
    end

    it 'returns unique results in order for multiple files' do
      options_multiple_paths[:unique] = true
      result = Parser::LogParser.new(options_multiple_paths).parse

      expect(result).to eq({ page1 => 3, page => 2, page2 => 1 })
    end
  end
end
