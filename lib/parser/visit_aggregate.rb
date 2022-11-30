
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
  end
end