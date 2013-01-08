require 'spec_helper'

describe JSTP::WebSocket::Pool do 
  it 'should be a Singleton' do
    JSTP::WebSocket::Pool.ancestors.should include Singleton
  end

  describe '#client' do 
    context 'there is no connection for that address' do 
      before do
        @web_socket_client = stub 'web socket client'
        @resource = ["localhost", "hola", "quetal"]
      end

      it 'should initialize the websocket client' do 
        EventMachine::WebSocketClient.should_receive(:connect)
          .with("ws://#{@resource.first}:33333/#{@resource[1..-1].join('/')}")
          .and_return @web_socket_client

        JSTP::WebSocket::Pool.instance
          .client(@resource)
          .should == @web_socket_client
      end
    end
  end
end