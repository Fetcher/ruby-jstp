# -*- encoding : utf-8 -*-
require 'singleton'
require 'em-websocket'
require 'em-websocket-client'
require 'json'
require 'discoverer'

require 'jstp/web_socket'
require 'jstp/tcp'

require 'jstp/api'
require 'jstp/connector'

require 'writer/jstp/connector'
require 'reader/jstp/connector'

class << self
  include JSTP::API
end
