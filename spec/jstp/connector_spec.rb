# -*- encoding : utf-8 -*-
require 'spec_helper'

describe JSTP::Connector do 
  it 'should be a singleton' do 
    JSTP::Connector.ancestors.should include Singleton
  end

  it 'should include a discoverer for Writer' do
    JSTP::Connector.ancestors.should include Discoverer::Writer 
  end

  describe '#dispatch' do 
    before do 
      @message = stub 'message'
      @writer = stub 'writer'
    end

    context 'websocket strategy' do 
      it 'should send the message to the websocket method in the writer' do 
        JSTP::Connector.instance.strategy = :websocket

        JSTP::Connector.instance.should_receive(:to)
          .and_return @writer 
        @writer.should_receive(:websocket)
          .with @message
        JSTP::Connector.instance.dispatch @message
      end
    end

    context 'tcp strategy' do 
      it 'should send the message to the tcp method in the writer' do 
        JSTP::Connector.instance.strategy = :tcp

        JSTP::Connector.instance.should_receive(:to)
          .and_return @writer 
        @writer.should_receive(:tcp)
          .with @message
        JSTP::Connector.instance.dispatch @message
      end
    end
  end

  describe '#server' do 
    before do 
      JSTP::Connector.instance.port = 33333
    end

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

  describe '#start' do 
    it 'should run EventMachine with the JSTP::EventMachine proc' do 
      JSTP::EventMachine.should_receive :call

      EventMachine.should_receive(:run)
        .with &JSTP::EventMachine

      JSTP::Connector.instance.start
    end
  end
end
