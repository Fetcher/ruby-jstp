module JSTP
  class Controller
    attr_reader :protocol, :method, :referer, :resource, :timestamp, :token, :original, :query, :body, :engine
    
    def initialize original, query, engine
      @original = original
      @engine = engine

      @protocol = original.protocol
      @method = original.method
      @referer = original.referer
      @timestamp = original.timestamp
      @token = original.token
      @resource = original.resource
      @query = query
      @body = original.body

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
  end
end