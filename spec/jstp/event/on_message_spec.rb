# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'JSTP::Event::OnMessage' do 
  it 'should call the registered block with the parsed message' do 
    @the_proc = stub 'the proc'
    @message = stub 'message'
    @parsed_message = stub 'parsed message'

    JSON.should_receive(:parse).with(@message)
      .and_return @parsed_message

    JSTP::Registry.instance.should_receive(:get)
      .and_return @the_proc

    @the_proc.should_receive(:call)
      .with @parsed_message

    JSTP::Event::OnMessage.call @message
  end
end
