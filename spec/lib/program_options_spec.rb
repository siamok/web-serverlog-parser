# frozen_string_literal: true

require 'program_options'

describe ProgramOptions do
  describe '#parse' do
    context 'showing help' do
      let(:my_argv) { ['-h'] }

      it 'parses help and shuts down' do
        ARGV.replace(my_argv)
        ProgramOptions.new.parse
      rescue SystemExit => e
        expect(e.status).to eq(0)
      end
    end

    context 'parsing arguments' do
      let(:path) { 'resources/test.log' }
      let(:path1) { 'webserver.log' }
      let(:output) { 'output.log' }

      it 'parses paths' do
        ARGV.replace([path, path1])
        program_params = ProgramOptions.new.parse

        expect(program_params[:paths]).to eq([path, path1])
      end

      it 'parses output' do
        ARGV.replace([path, path1, '-o', output])
        program_params = ProgramOptions.new.parse

        expect(program_params[:output]).to eq(output)
      end

      it 'fails when output is mixed with paths' do
        ARGV.replace([path, '-o', output, path1])
        ProgramOptions.new.parse
      rescue SystemExit => e
        expect(e.status).to eq(1)
      end

      it 'fails when other option is provided' do
        ARGV.replace([path, path1, '-g'])
        ProgramOptions.new.parse
      rescue SystemExit => e
        expect(e.status).to eq(1)
      end
    end
  end
end
