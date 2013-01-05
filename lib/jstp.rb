require 'singleton'
require 'em-websocket'
require 'em-websocket-client'
require 'json'

require 'jstp/event/on_message'
require 'jstp/connector'
require 'jstp/api'
require 'jstp/registry'
require 'jstp/server'
require 'jstp/event_machine'

module JSTP
  class << self
    include API
  end
end