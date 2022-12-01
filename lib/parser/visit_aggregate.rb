# frozen_string_literal: true

module Parser
  class VisitAggregate
    attr_reader :visits

    def initialize
      @visits = {}
    end

    def add(page, ip)
      @visits[page] = Parser::Visit.new unless visits.key?(page)

      @visits[page].add(ip)
    end

    def result(unique: false)
      pages = @visits.each_with_object({}) do |(page, visit), acc|
        value = unique ? visit.ips.size : visit.count

        acc[page] = value
      end
      pages.sort_by { |_k, v| v }.reverse.to_h
    end
  end
end
