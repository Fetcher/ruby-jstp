# -*- encoding : utf-8 -*-
require 'singleton'
require 'em-websocket'
require 'em-websocket-client'
require 'json'
require 'discoverer'

require 'jstp/event/on_message'
require 'jstp/web_socket/pool'
require 'jstp/connector'
require 'jstp/api'
require 'jstp/registry'
require 'jstp/server'
require 'jstp/event_machine'

require 'writer/jstp/connector'

class << self
  include JSTP::API
end
