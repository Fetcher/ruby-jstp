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

      JSTP::WebSocket.instance.should_receive(:client)
        .with(@message["resource"])
        .and_return @web_socket_client

      @web_socket_client.should_receive(:callback)

      @message.should_receive(:to_json).and_return @message_json

      @writer.websocket @message      
    end

    it 'should send the message from the callback' do 
      pending "I'm unable to test this properly since providing a Proc will make me lose scope for the client"
      @writer = Writer::JSTP::Connector.new @connector

      JSTP::WebSocket.should_receive(:client)
        .with(@message["resource"])
        .and_return @web_socket_client

      @web_socket_client.should_receive(:callback)

      @message.should_receive(:to_json).and_return @message_json
      @web_socket_client.should_receive(:send_msg)
        .with(@message_json)

      @writer.websocket @message      
    end
  end

  describe '#tcp' do 
    it 'should get the resource and use it as host, then send the dispatch in JSON' do
      message = stub 'message'
      message_json = stub 'message json'
      resource = stub 'resource'
      hostname = stub 'hostname'
      socket = stub 'socket'

      message.should_receive(:[]).with("resource")
        .and_return resource

      resource.should_receive(:first).and_return hostname

      JSTP::Connector.instance.should_receive(:port).
        and_return 4444

      TCPSocket.should_receive(:open).with(hostname, 4444)
        .and_return socket

      message.should_receive(:to_json).and_return message_json

      socket.should_receive(:puts).with message_json

      writer = Writer::JSTP::Connector.new ::JSTP::Connector.instance
      writer.tcp message
    end
  end
end