module JSTP
  class Controller
    def initialize message
      @protocol = message["protocol"]
      @method = message["method"]
      @referer = message["referer"]
      @timestamp = message["timestamp"]
      @token = message["token"]
      @resource = message["resource"]
    end
  end
end