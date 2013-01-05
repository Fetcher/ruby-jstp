require 'spec_helper'

describe 'JSTP::Server' do 
  it 'should set JSTP::Event::OnMessage to onmessage' do
    server = stub 'server'
    JSTP::Event::OnMessage.stub :call

    server.should_receive(:onmessage)
      .with(&JSTP::Event::OnMessage)

    JSTP::Server.call server
  end
end