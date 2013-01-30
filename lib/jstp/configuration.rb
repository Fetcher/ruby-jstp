module JSTP
  class Configuration
    include Singleton

    def initialize
      @port = SymbolMatrix :inbound => 33333, :outbound => 33333
      @strategy = SymbolMatrix :inbound => :tcp, :outbound => :tcp
      @logger = Logger.new $stdout
      @hostname = `hostname`
    end

    def port argument = nil
      @port = argument unless argument.nil?
      @port
    end

    def strategy argument = nil
      @strategy = argument unless argument.nil?
      @strategy
    end

    def hostname argument = nil
      @hostname = argument unless argument.nil?
      @hostname
    end

    def logger argument = nil
      @logger = argument unless argument.nil?
      @logger
    end
  end
end