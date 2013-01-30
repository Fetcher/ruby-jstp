# -*- encoding : utf-8 -*-
require 'singleton'
require 'em-websocket'
require 'em-websocket-client'
require 'json'
require 'discoverer'
require 'symbolmatrix'
require 'uuid'

require 'jstp/web_socket'

require 'jstp/api'
require 'jstp/base'
require 'jstp/connector'

require 'jstp/engine'
require 'jstp/controller'

require 'writer/jstp/connector'
require 'reader/jstp/connector'

# Node for the JSTP protocol. Reference implementation in Ruby
module JSTP

  # Configure the JSTP node. Usage:
  #    JSTP.config do |config|
  #      config.port :inbound => 33333, :outbound => 33333
  #      config.strategy :inbound => :tcp, :outbound => :websocket
  #      config.logger Logger.new $stdout
  #      config.hostname `hostname` 
  def self.config &block
    block.call Configuration.instance
  end
end
