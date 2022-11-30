#!/usr/bin/env ruby
# frozen_string_literal: true

require './lib/program_options'

begin
  program_options = ProgramOptions.new.read_arguments
rescue ArgumentError => e
  puts e.message
  exit(1)
end
