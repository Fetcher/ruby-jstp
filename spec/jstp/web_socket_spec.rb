require 'spec_helper'

describe JSTP::WebSocket do 
  it 'should be a singleton' do 
    JSTP::WebSocket.ancestors.should include Singleton
  end

  describe '#event_machine' do 
    before do 
      JSTP::Connector.instance.port = 33333
    end

    it 'should start a websocket server in 33333' do 
      JSTP::WebSocket.instance.server_setup
        .should_receive :call

      EventMachine::WebSocket.should_receive(:start)
        .with({ host: '0.0.0.0', port: 33333 }, &JSTP::WebSocket.instance.server_setup)

      JSTP::WebSocket.instance.event_machine.call
    end
  end

  describe '#server_setup' do 
    it 'should set #event_on_message to onmessage' do
      server = stub 'server'
      JSTP::WebSocket.instance.event_on_message.should_receive :call

      server.should_receive(:onmessage)
        .with &JSTP::WebSocket.instance.event_on_message

      JSTP::WebSocket.instance.server_setup.call server
    end
  end

  describe '#event_on_message' do 
    it 'should call the registered block with the parsed message' do 
      @the_proc = stub 'the proc'
      @message = stub 'message'
      @parsed_message = stub 'parsed message'

      JSON.should_receive(:parse).with(@message)
        .and_return @parsed_message

      JSTP::Connector.instance.should_receive(:block)
        .and_return @the_proc

      @the_proc.should_receive(:call)
        .with @parsed_message

      JSTP::WebSocket.instance.event_on_message.call @message
    end
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

        JSTP::WebSocket.instance
          .client(@resource)
          .should == @web_socket_client
      end
    end
  end
end