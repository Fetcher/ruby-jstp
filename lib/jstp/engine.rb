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
      if @config.gateway && host != @config.hostname && host != 'localhost'
        # May be we should gateway this message, if this wasn't aimed at us
        message.to.send @config.strategy.outbound
      else
        if the_class.ancestors.include? JSTP::Controller
          resource = the_class.new message, query, self
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
  end
end