module JSTP
  class Engine
    include Discoverer::Reader

    def initialize test = false
      @config = Configuration.instance
      from.send @config.strategy.inbound unless test
    end
    
    # Processes the dispatch in the new REST engine way
    def dispatch message, client
      host, the_class, query = discover_resource message["resource"].clone
      if @config.gateway.forward && host != @config.hostname && host != 'localhost'
        # May be we should gateway this message, if this wasn't aimed at us
        message.to.send @config.strategy.outbound
      else
        # Is there a reverse gateway token there?
        if @config.gateway.reverse && message.gateway == 'reverse'
          if clients.has_key? message.token.first
            clients[message.token.first].send message.to.json
            @config.logger.debug message.to.string
          else
            raise ClientNotFoundError, "Client #{message.token.first} is not registered in this server"
          end
        else
          if the_class.ancestors.include? JSTP::Controller
            resource = the_class.new message, query, self, client
            resource.send message["method"].downcase.to_sym
          else
            if @config.environment == :development
              raise NotAControllerError, "The resource class #{the_class} for #{message["resource"].join("/")} was found, but is not a JSTP::Controller"
            else
              raise NotPermittedError, "The selected resource is forbidden for this type of request"
            end
          end
        end
      end
    end

    def discover_resource resource_stack
      response = []
      response << resource_stack.shift
      class_stack = "::#{self.class}::"
      query = []
      resource_stack.each do |item|
        begin
          capitalized = item[0].upcase + item[1..-1]
          eval(class_stack + capitalized)
          class_stack += "#{capitalized}::"
        rescue NameError, SyntaxError
          query << item
        end
      end
      response << eval(class_stack[0..-3])
      response << query
      return response
    end

    def clients
      @clients ||= {}
    end

    class NotPermittedError < RuntimeError; end
    class NotAControllerError < RuntimeError; end
    class ClientNotFoundError < RuntimeError; end

    # DSL for configuration
    def self.port argument = nil
      Configuration.instance.port argument
    end

    def self.port= argument
      Configuration.instance.port = argument
    end

    def self.strategy argument = nil
      Configuration.instance.strategy argument
    end

    def self.strategy= argument
      Configuration.instance.strategy = argument
    end

    def self.logger argument = nil
      Configuration.instance.logger argument
    end

    def self.logger= argument
      Configuration.instance.logger = argument
    end

    def self.hostname argument = nil
      Configuration.instance.hostname argument
    end

    def self.hostname= argument
      Configuration.instance.hostname = argument
    end

    def self.environment argument = nil
      Configuration.instance.environment argument
    end

    def self.environment= argument
      Configuration.instance.environment = argument
    end

    def self.gateway argument = nil
      Configuration.instance.gateway argument
    end

    def self.gateway= argument
      Configuration.instance.gateway = argument
    end
  end
end