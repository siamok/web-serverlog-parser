# frozen_string_literal: true

class OutputWriter
  def initialize(options)
    @options = options
  end

  def flush(input)
    out = prepare_out(input)

    case output_file
    when nil
      flush_screen(out)
    else
      flush_file(out)
    end
  end

  private

  def prepare_out(input)
    input.map do |page, visit|
      format("#{page} #{visit} visit%s", (visit == 1 ? '' : 's'))
    end
  end

  def flush_screen(out)
    puts out
  end

  def flush_file(out)
    File.open(output_file, 'w') do |file|
      file.write(out.join("\n"))
    end
  end

  def output_file
    @options[:output]
  end
end
