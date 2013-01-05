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
  end
end