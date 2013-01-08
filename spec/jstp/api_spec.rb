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
    context 'websocket strategy' do 
      before do 
        JSTP::Connector.instance.strategy = :websocket
      end

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

    context 'tcp strategy' do 
      before do 
        JSTP::Connector.instance.strategy = :tcp
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

          writer.should_receive(:tcp)
            .with message

          o = Object.new
          o.extend JSTP::API
          o.dispatch message 
        end
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
      o.port 3000

      JSTP::Connector.instance.port.should == 3000
    end
  end
end
