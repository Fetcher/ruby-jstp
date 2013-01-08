# -*- encoding : utf-8 -*-
require 'spec_helper'

describe JSTP::API do 
  describe '#dispatch' do 
    context 'a block is passed' do 
      it 'should register the block and send JSTP::Server to the EventMachine reactor' do
        block = proc {
          "lalal"
        }

        JSTP::Registry.instance.should_receive(:set)
          .with block

        JSTP::EventMachine.should_receive :call
        EventMachine.should_receive(:run)
          .with &JSTP::EventMachine

        o = Object.new
        o.extend JSTP::API
        o.dispatch &block
      end
    end

    context 'an argument is passed' do 
      it 'should dispatch the message via the Connector' do
        message = stub 'message'
        JSTP::Connector.instance.should_receive(:dispatch)
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
