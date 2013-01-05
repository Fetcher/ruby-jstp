require 'spec_helper'

describe JSTP::Connector do 
  it 'should be a singleton' do 
    JSTP::Connector.ancestors.should include Singleton
  end

  describe '#dispatch' do 
    before do 
      @message = {
        "protocol" => ["JSTP", "0.1"],
        "method" => "POST", 
        "resource" => [
          "session.manager",
          "User"
        ],
        "timestamp" => 1357334118,
        "token" => 3523902859084057289594,
        "referer" => [
          "browser",
          "Registerer"
        ],
        "body" => {
          "login" => "xavier",
          "email" => "xavier@fetcher.com",
          "password" => "secret"
        }
      }

      @web_socket_client = stub 'web socket client'
      @message_json = stub 'message json'
    end

    it 'should open a websocket to the correct resource in the standard port 33333 and set the callback' do 
      JSTP::Connector.instance.should_receive(:client)
        .with(@message["resource"])
        .and_return @web_socket_client

      @web_socket_client.should_receive(:send_msg)
        .with(@message_json)
      @message.should_receive(:to_json).and_return @message_json

      JSTP::Connector.instance.dispatch @message
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

        JSTP::Connector.instance
          .client(@resource)
          .should == @web_socket_client
      end
    end
  end

  describe '#server' do 
    it 'should start a websocket server in 33333' do 
      JSTP::Server.should_receive :call
      EventMachine::WebSocket.should_receive(:start)
        .with({ host: '0.0.0.0', port: 33333 }, &JSTP::Server)

      JSTP::Connector.instance.server
    end

    it 'should pass the proc JSTP::Server' do
      pending "Warning, this isn't actually testing the JSTP::Server, I don't know why"
    end
  end
end