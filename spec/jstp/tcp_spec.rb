require 'spec_helper'

describe JSTP::TCP do 
  it 'should be a singleton' do 
    JSTP::TCP.ancestors.should include Singleton
  end

  describe '#client' do 
    it 'should return an initialized TCP client' do 
      socket = stub 'socket'
      hostname = stub 'hostname'
      port = stub 'port'

      TCPSocket.should_receive(:open).with(hostname, port)
        .and_return socket

      JSTP::TCP.instance.client(hostname, port).should == socket
    end
  end
end