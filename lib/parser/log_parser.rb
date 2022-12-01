# frozen_string_literal: true

module Parser
  class LogParser
    attr_reader :options

    def initialize(options)
      @options = options
    end

    def parse
      @visits = Parser::VisitAggregate.new
      paths.each do |path|
        File.foreach(path) do |line|
          if match = /^(?<page>\/\w*\/\d?)\s*(?<ip>\d\.\d\.\d\.\d)$/.match(line)
            visits.add(*match.captures)
          end
        end
      end

      visits.result(unique: options[:unique])
    end

    private

    def visits
      @visits ||= Parser::VisitAggregate.new
    end

    def paths
      options[:paths]
    end
  end
end
