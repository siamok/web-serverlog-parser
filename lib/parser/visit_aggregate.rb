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
      pages = @visits.each_with_object({}) do |visit, acc|
        value = unique ? visit.last.ips.size : visit.last.count

        acc[visit.first] = value
      end
      pages.sort_by { |_k, v| v }.reverse.to_h
    end
  end
end
