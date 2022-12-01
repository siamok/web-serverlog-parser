# frozen_string_literal: true

require 'output_writer'

describe OutputWriter do
  describe '#flush' do
    let(:input) { { '/test/1' => 4, '/test/' => 2, '/test/2' => 1 } }
    let(:output_string) do
      "/test/1 4 visits\n/test/ 2 visits\n/test/2 1 visit\n"
    end

    context 'output_file not provided' do
      let(:output_file) { nil }
      let(:options) { { output: output_file } }

      it 'flushes output on screen' do
        expect do
          OutputWriter.new(options).flush(input)
        end.to output(output_string).to_stdout
      end
    end

    context 'output_file provided' do
      let(:output_file) { 'test.log' }
      let(:options) { { output: output_file } }
      let(:output_string) do
        "/test/1 4 visits\n/test/ 2 visits\n/test/2 1 visit"
      end

      before do
        file = double('file')
        allow(File).to receive(:open).with(output_file, 'w').and_yield(file)
        expect(file).to receive(:write).with(output_string)
      end

      it 'flushes output on screen' do
        OutputWriter.new(options).flush(input)
      end
    end
  end
end
