require 'spec_helper'

describe Writer::JSTP::Connector do 
  describe '#websocket' do 
    before do 
      @connector = stub 'connector'
      @message = { "resource" => ["lala"] }
      @message_json = stub 'message_json'
      @web_socket_client = stub 'web socket client'
    end

    it 'should get the client from the pool and set the callback' do
      @writer = Writer::JSTP::Connector.new @connector

      JSTP::WebSocket::Pool.instance.should_receive(:client)
        .with(@message["resource"])
        .and_return @web_socket_client

      @web_socket_client.should_receive(:callback)

      @message.should_receive(:to_json).and_return @message_json

      @writer.websocket @message      
    end

    it 'should send the message from the callback' do 
      pending "I'm unable to test this properly since providing a Proc will make me lose scope for the client"
      @writer = Writer::JSTP::Connector.new @connector

      JSTP::WebSocket::Pool.should_receive(:client)
        .with(@message["resource"])
        .and_return @web_socket_client

      @web_socket_client.should_receive(:callback)

      @message.should_receive(:to_json).and_return @message_json
      @web_socket_client.should_receive(:send_msg)
        .with(@message_json)

      @writer.websocket @message      
    end
  end
end