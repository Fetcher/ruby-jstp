# -*- encoding : utf-8 -*-
require 'singleton'
require 'em-websocket'
require 'em-websocket-client'
require 'json'
require 'discoverer'
require 'symbolmatrix'
require 'uuid'
require 'oj'
require 'logger'

require 'jstp/engine'
require 'jstp/controller'
require 'jstp/dispatch'
require 'jstp/configuration'
require 'jstp/version'

require 'reader/jstp/engine'
require 'reader/jstp/dispatch'
require 'writer/jstp/dispatch'

# Node for the JSTP protocol. Reference implementation in Ruby
module JSTP

  # Configure the JSTP node. Usage:
  #
  #     JSTP.config do |config|
  #       config.port :inbound => 33333, :outbound => 33333
  #       config.strategy :inbound => :tcp, :outbound => :websocket
  #       config.logger Logger.new $stdout
  #       config.hostname `hostname` 
  #       config.gateway true
  #     end
  def self.config &block
    block.call Configuration.instance
  end
end
