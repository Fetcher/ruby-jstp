module JSTP
  class Configuration
    include Singleton

    def initialize
      @port = SymbolMatrix :inbound => 33333, :outbound => 33333
      @strategy = SymbolMatrix :inbound => :tcp, :outbound => :tcp
      @logger = Logger.new $stdout
      @hostname = (`hostname`)[0..-2]
      @environment = :development
      @gateway = true
    end

    def port argument = nil
      @port = SymbolMatrix argument unless argument.nil?
      @port
    end

    def port= argument
      port argument
    end

    def strategy argument = nil
      @strategy = SymbolMatrix argument unless argument.nil?
      @strategy
    end

    def strategy= argument
      strategy argument
    end

    def hostname argument = nil
      @hostname = argument unless argument.nil?
      @hostname
    end

    def hostname= argument
      hostname argument
    end

    def logger argument = nil
      @logger = argument unless argument.nil?
      @logger
    end

    def logger= argument
      logger argument
    end

    def gateway argument = nil
      @gateway = argument unless argument.nil?
      @gateway
    end

    def gateway= argument
      gateway argument
    end

    def environment argument = nil
      @environment = argument unless argument.nil?
      @environment
    end

    def environment= argument
      environment argument
    end
  end
end