module JSTP
  class WebSocket
    include Singleton

    def server_setup
      @server_setup ||= proc { |server|
        server.onmessage &WebSocket.instance.event_on_message
      }
    end

    def event_machine
      @event_machine ||= proc {
        ::EM::WebSocket.start host: "0.0.0.0", 
                              port: Connector.instance.port.inbound, 
                              &WebSocket.instance.server_setup
      }
    end

    def event_on_message
      @event_on_message ||= proc { |message|
        Connector.instance.block.call JSON.parse message
      }
    end

    def client resource
      ::EM::WebSocketClient
        .connect "ws://#{resource.first}:#{Connector.instance.port.outbound}/#{resource[1..-1].join('/')}"
    end
  end
end