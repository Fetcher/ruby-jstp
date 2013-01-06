module JSTP

  # Handles the connection functionality for this JSTP reference implementation
  class Connector
    include Singleton

    # Discovers the server and sends the message
    # @param [Hash/Array] message
    def dispatch message
      this_client = client(message["resource"])
      this_client.callback do 
        this_client.send_msg message.to_json
      end
    end

    # Access to the client pool
    # @param [Array] the resource data
    # @return [EventMachine::WebSocketClient] the client for the address
    def client resource
      ::EventMachine::WebSocketClient.connect "ws://#{resource.first}:33333/#{resource[1..-1].join('/')}"
    end

    # Sets up the server to be executed within an EventMachine reactor
    def server
      ::EventMachine::WebSocket.start host: "0.0.0.0", port: 33333, &JSTP::Server
    end
  end
end