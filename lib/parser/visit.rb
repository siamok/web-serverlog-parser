module Parser
  class Visit
    attr_accessor :count

    def initialize
      @count = 0
      @ips = Set.new
    end

    def add(ip)
      @ips.add(ip)
      @count += 1
    end

    def ips
      @ips.to_a
    end
  end
end
