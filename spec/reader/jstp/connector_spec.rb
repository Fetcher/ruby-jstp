require 'spec_helper'

describe Reader::JSTP::Connector do 
  describe '#websocket' do 
    it 'should run EventMachine with the JSTP::EventMachine proc' do 
      JSTP::WebSocket::EventMachine.should_receive :call

      EventMachine.should_receive(:run)
        .with &JSTP::WebSocket::EventMachine

      reader = Reader::JSTP::Connector.new stub 'connector'
      reader.websocket
    end    
  end
end