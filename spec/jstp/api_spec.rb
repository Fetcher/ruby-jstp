# -*- encoding : utf-8 -*-
require 'spec_helper'

describe JSTP::API do 
  describe '#strategy' do 
    it 'should set the strategy' do 
      o = Object.new
      o.extend JSTP::API

      o.strategy inbound: :websocket, outbound: :tcp

      JSTP::Connector.instance.strategy.inbound.should == :websocket
      JSTP::Connector.instance.strategy.outbound.should == :tcp
    end
  end

  describe '#dispatch' do 
    before do 
      JSTP::Connector.instance.strategy = SymbolMatrix inbound: :tcp, outbound: :websocket
    end

    context 'a block is passed' do 
      it 'should register the block and send JSTP::Server to the EventMachine reactor' do
        block = proc { "lalal" }
        reader = stub 'reader'

        JSTP::Connector.instance.should_receive(:block=)
          .with block

        JSTP::Connector.instance.should_receive(:from)
          .and_return reader
        reader.should_receive :tcp

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

    context 'no argument, no block' do 
      it 'should return the JSTP::Connector.instance' do 
        o = Object.new
        o.extend JSTP::API
        o.dispatch.should == JSTP::Connector.instance
      end
    end
  end

  describe '#port' do 
    it 'should configure the port number' do 
      message = {
        "resource" => ["localhost"]
      }
      o = Object.new
      o.extend JSTP::API
      o.port inbound: 3000, outbound: 4000

      JSTP::Connector.instance.port.inbound.should == 3000
      JSTP::Connector.instance.port.outbound.should == 4000
    end
  end
end
