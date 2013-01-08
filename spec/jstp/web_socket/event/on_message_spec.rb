# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'JSTP::WebSocket::Event::OnMessage' do 
  it 'should call the registered block with the parsed message' do 
    @the_proc = stub 'the proc'
    @message = stub 'message'
    @parsed_message = stub 'parsed message'

    JSON.should_receive(:parse).with(@message)
      .and_return @parsed_message

    JSTP::Connector.instance.should_receive(:block)
      .and_return @the_proc

    @the_proc.should_receive(:call)
      .with @parsed_message

    JSTP::WebSocket::Event::OnMessage.call @message
  end
end
