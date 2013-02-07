module JSTP
  class Controller
    attr_reader :protocol, :method, :referer, :resource, :timestamp, :token, :original, :query, :body, :engine, :client
    
    def initialize original, query, engine, client = nil
      @original = original
      @engine = engine

      @query = query
      @client = client unless client.nil?

      Configuration.instance.logger.info original.to.short
    end

    # Since it delegates Reader::Dispatch, the method is
    # @param Method
    # @param Resource
    # @param Body
    # @param Headers
    def dispatch *args
      @dispatch = Dispatch.new @original
      @dispatch.referer = [Configuration.instance.hostname] + (self.class.to_s.split("::") - engine.class.to_s.split("::"))
      @dispatch.from.array args

      @dispatch
    end

    def protocol
      original.protocol
    end

    def method
      original.method
    end

    def referer
      original.referer
    end

    def timestamp
      original.timestamp
    end

    def token
      original.token
    end

    def resource
      original.resource
    end

    def body
      original.body
    end
  end
end