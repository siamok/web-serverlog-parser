#!/usr/bin/env ruby
# frozen_string_literal: true

require './lib/program_options'
require './lib/output_writer'
require './lib/parser'

begin
  program_options = ProgramOptions.new.read_arguments
rescue ArgumentError => e
  puts e.message
  exit(1)
end

results = Parser::LogParser.new(program_options).parse
OutputWriter.new(program_options).flush(results)
