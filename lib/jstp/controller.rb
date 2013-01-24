module JSTP
  class Controller
    include JSTP::API
    
    def initialize message
      @protocol = message["protocol"]
      @method = message["method"]
      @referer = message["referer"]
      @timestamp = message["timestamp"]
      @token = message["token"]
      @resource = message["resource"]
      @message = message
      @response = message.clone
      @response["body"] = {}
    end
  end
end