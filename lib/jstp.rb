# -*- encoding : utf-8 -*-
require 'singleton'
require 'em-websocket'
require 'em-websocket-client'
require 'json'
require 'discoverer'

require 'jstp/web_socket/event/on_message'
require 'jstp/web_socket/pool'
require 'jstp/web_socket/event_machine'
require 'jstp/web_socket/server'

require 'jstp/api'
require 'jstp/connector'

require 'writer/jstp/connector'
require 'reader/jstp/connector'

class << self
  include JSTP::API
end
