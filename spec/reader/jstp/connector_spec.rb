require 'spec_helper'

describe Reader::JSTP::Connector do 
  describe '#websocket' do 
    it 'should run EventMachine with the JSTP::EventMachine proc' do 
      JSTP::WebSocket.instance.event_machine.should_receive :call

      EventMachine.should_receive(:run)
        .with &JSTP::WebSocket.instance.event_machine

      reader = Reader::JSTP::Connector.new stub 'connector'
      reader.websocket
    end    
  end

  describe '#tcp' do 
    it 'should create the server and start it' do 
      pending 'I still can test infinite loops'
      
      tcp_server = stub 'tcp server'

      TCPServer.should_receive(:open)
        .with(JSTP::Connector.instance.port)
        .and_return tcp_server

      tcp_server.should_receive(:accept)

      reader = Reader::JSTP::Connector.new stub 'connector'
      reader.tcp
    end
  end
end