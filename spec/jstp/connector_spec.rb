# -*- encoding : utf-8 -*-
require 'spec_helper'

describe JSTP::Connector do 
  it 'should be a singleton' do 
    JSTP::Connector.ancestors.should include Singleton
  end

  it 'should include a discoverer for Writer' do
    JSTP::Connector.ancestors.should include Discoverer::Writer 
  end

  it 'should include a discoverer for Reader' do 
    JSTP::Connector.ancestors.should include Discoverer::Reader
  end

  describe '#server' do 
    before do 
      JSTP::Connector.instance.port = 33333
    end

    it 'should start a websocket server in 33333' do 
      JSTP::WebSocket::Server.should_receive :call
      EventMachine::WebSocket.should_receive(:start)
        .with({ host: '0.0.0.0', port: 33333 }, &JSTP::WebSocket::Server)

      JSTP::Connector.instance.server
    end

    it 'should pass the proc JSTP::Server' do
      pending "Warning, this isn't actually testing the JSTP::Server, I don't know why"
    end
  end
end
