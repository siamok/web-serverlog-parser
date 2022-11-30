# frozen_string_literal: true

require 'program_options'

describe ProgramOptions do
  describe '#read_arguments' do
    let(:program_options) { ProgramOptions.new.read_arguments }
    context 'showing help' do
      let(:my_argv) { ['-h'] }

      it 'parses help and shuts down' do
        ARGV.replace(my_argv)

        expect { program_options }.to raise_error(SystemExit)
      end
    end

    context 'parsing arguments' do
      let(:path) { 'resources/test.log' }
      let(:path1) { 'webserver.log' }
      let(:output) { 'output.log' }
      let(:errors) do
        {
          missing_path: 'Missing path argument',
          unexpected_option: 'Unexpected option: %s',
          empty_option: 'Empty output: %s',
          unexpected_path: 'Unexpected path after output: %s'
        }
      end

      let(:error_append) { 'Type -h for help' }

      def error_message(error)
        "#{error}. #{error_append}"
      end

      it 'parses paths' do
        ARGV.replace([path, path1])

        expect(program_options[:paths]).to eq([path, path1])
      end

      it 'parses output' do
        ARGV.replace([path, path1, '-o', output])

        expect(program_options[:output]).to eq(output)
      end

      it 'fails when output is mixed with paths' do
        ARGV.replace([path, '-o', output, path1])
        program_options
      rescue ArgumentError => e
        expect(e.message).to eq(error_message(errors[:unexpected_path]) % path1)
      end

      it 'fails when other option is provided' do
        ARGV.replace([path, path1, '-g'])
        program_options
      rescue ArgumentError => e
        expect(e.message).to eq(error_message(errors[:unexpected_option]) % '-g')
      end

      it 'fails when option is not provided' do
        ARGV.replace([path, path1, '-o'])
        program_options
      rescue ArgumentError => e
        expect(e.message).to eq(error_message(errors[:empty_option]) % '-o')
      end

      it 'fails when path is not provided' do
        ARGV.replace(['-o', 'output'])
        program_options
      rescue ArgumentError => e
        expect(e.message).to eq(error_message(errors[:missing_path]))
      end
    end
  end
end
