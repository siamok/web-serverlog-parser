# frozen_string_literal: true

class ProgramOptions
  OPTIONS = %w[o u].freeze

  attr_reader :paths, :unique, :output

  def initialize
    @paths = []
    @output = nil
    @state = :paths
    @unique = false
  end

  def read_arguments
    return if parse_help

    process_args

    show_error('Empty output: -o') if @state == :output
    show_error('Missing path argument') if @paths.empty?

    { paths: paths, output: output, unique: unique }
  end

  private

  def process_args
    ARGV.each do |arg|
      if arg.start_with?('-')
        validate_option(arg[1..])
      else
        parse_arg(arg)
      end
    end
  end

  def parse_help
    return unless ARGV.include?('-h')

    print_help
  end

  def print_help
    puts 'usage ./parser <path>[,<path>...]'
    puts "\t-o <output_path> - specified output file"
    puts "\t-u - unique value"
    puts "\t-h - this message"

    exit(true)
  end

  def parse_arg(arg)
    case @state
    when :paths
      parse_paths(arg)
    when :output
      parse_output(arg)
    end
  end

  def validate_option(option)
    show_error("Unexpected option: -#{option}") unless OPTIONS.include?(option)

    case option
    when 'o'
      @state = :output
    when 'u'
      @unique = true
    end
  end

  def parse_paths(arg)
    show_error("Unexpected path after output: #{arg}") unless output.nil?

    @paths.push(arg)
  end

  def parse_output(arg)
    show_error('Duplicated output') unless output.nil?

    @output = arg
    @state = :paths
  end

  def show_error(error)
    raise ArgumentError, "#{error}. Type -h for help"
  end
end
