module JSTP
  class Configuration
    include Singleton

    def initialize
      @port = SymbolMatrix :inbound => 33333, :outbound => 33333
      @strategy = SymbolMatrix :inbound => :tcp, :outbound => :tcp
      @logger = Logger.new $stdout
      @hostname = (`hostname`)[0..-2]
      @current_engine = nil
    end

    def port argument = nil
      @port = SymbolMatrix argument unless argument.nil?
      @port
    end

    def strategy argument = nil
      @strategy = SymbolMatrix argument unless argument.nil?
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

    def current_engine argument = nil
      @current_engine = argument unless argument.nil?
      @current_engine
    end
  end
end