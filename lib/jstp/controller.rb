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

    def dispatch method = nil, resource = nil, body = {}, headers = {}
      @dispatch ||= Dispatch.new @original
      @dispatch.method = method if method
      @dispatch.resource = resource unless resource.nil?
      @dispatch.body = body
      @dispatch.referer = [Configuration.instance.hostname] + (self.class.to_s.split("::") - engine.class.to_s.split("::"))

      headers.each do |key, value|
        @dispatch[key] = value
      end
      @dispatch
    end
  end
end