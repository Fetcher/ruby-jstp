# -*- encoding : utf-8 -*-
require 'spec_helper'

describe JSTP::API do 
  describe '#strategy' do 
    it 'should set the strategy' do 
      o = Object.new
      o.extend JSTP::API

      o.strategy :websocket

      JSTP::Connector.instance.strategy.should == :websocket
    end
  end

  describe '#dispatch' do 
    context 'a block is passed' do 
      it 'should register the block and send JSTP::Server to the EventMachine reactor' do
        block = proc { "lalal" }
        reader = stub 'reader'

        JSTP::Connector.instance.should_receive(:block=)
          .with block

        JSTP::Connector.instance.should_receive(:from)
          .and_return reader
        reader.should_receive :websocket

        o = Object.new
        o.extend JSTP::API
        o.dispatch &block
      end
    end

    context 'an argument is passed' do 
      it 'should dispatch the message via the Connector' do
        message = stub 'message'
        writer = stub 'writer'

        JSTP::Connector.instance.should_receive(:to)
          .and_return writer

        writer.should_receive(:websocket)
          .with message

        o = Object.new
        o.extend JSTP::API
        o.dispatch message 
      end
    end
  end

  describe '#port' do 
    it 'should configure the port number' do 
      pending "This is working, but it's untesteable because of Reactor pattern"
      message = {
        "resource" => ["localhost"]
      }
      o = Object.new
      o.extend JSTP::API
      o.port 3000

      ::EventMachine::WebSocket.should_receive(:start)
        .with(host: "0.0.0.0", port: 3000)

      o.dispatch do 
        "lala"
      end
    end
  end
end
