# {
#   "protocol": ["JSTP", "0.1"],
#   "method": "GET",
#   "resource": ["localhost", "User", "4"],
#   "timestamp": 1536345124,
#   "token": ["8ugw324", "34fqwer"],
#   "X-Server": "EventMachine",
#   "referer": ["google.com", "search"]
#   "body": {
#     "name": "Xavier"
#   }
# }

class Localhost < JSTP::Engine
  class User < JSTP::Controller
    def get
      protocol # => ["JSTP", "0.1"]
      method # => "GET"
      resource # => ["localhost", "User", "4"]
      query # => ["4"]
      timestamp # => 1536345124
      referer # => ["google.com", "search"]
      token # => ["8ugw324", "34fqwer"]
      headers # => {"token" => ..., timestamp => ..., "X-Server" => ...}
      body # => {"name" => "Xavier"}
      original # => {"protocol" => ..., method" => "GET", "resource" => ...}

      dispatch(
        :post, 
        "remote.host/Login/success", 
        { "message" => "Login successful for user #{body['name']}" },
        { "X-Greet" => "Hello" }
      ).to.websocket
      # => {
      #   "protocol": ["JSTP", "0.1"],
      #   "method": "POST",
      #   "resource": ["remote.host", "Login", "success"],
      #   "timestamp": 1536358924,
      #   "token": ["8ugw324", "34fqwer"],
      #   "X-Greet": "Hello",
      #   "body": {
      #     "message": "Login successful for user Xavier"
      #   }
      # }

      original.to_s 
      # => 
      # GET localhost/User/4
      # timestamp: 1536345124
      # token: 8ugw324/34fqwer
      # X-Server: EventMachine
      # referer: google.com/search
      #
      # name: Xavier

      original.to.short
      # => GET localhost/User/4?name:Xavier
    end
  end
end

Localhost.new