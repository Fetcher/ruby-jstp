JSTP.config do |c|
  c.strategy inbound: :websocket
  c.port inbound: 44444, outbound: 33333
end

class Diff < JSTP::Engine
  class Proxy < JSTP::Controller
    def put
      dispatch(:get, "localhost/User/7").to.tcp
    end
  end
end