# -*- encoding : utf-8 -*-
require 'spec_helper'

describe 'JSTP::WebSocket::Server' do 
  it 'should set JSTP::Event::OnMessage to onmessage' do
    server = stub 'server'
    JSTP::WebSocket::Event::OnMessage.stub :call

    server.should_receive(:onmessage)
      .with(&JSTP::WebSocket::Event::OnMessage)

    JSTP::WebSocket::Server.call server
  end
end
