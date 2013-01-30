require 'oj'

module Writer
  module JSTP
    class Dispatch
      attr_accessor :source

      def initialize source
        @source = source
        @config = ::JSTP::Configuration.instance
      end

      # Dispatch this applying the websocket strategy
      def websocket port = nil
        host = @source["resource"].first
        path = @source["resource"][1..-1].join('/')
        if port.nil?
          connection_uri = "ws://#{host}:#{@config.port.outbound}/#{path}"
        else
          connection_uri = "ws://#{host}:#{port}/#{path}"
        end

        begin 
          ws = EM::WebSocketClient.connect connection_uri
          ws.callback do 
            ws.send_msg @source.to.json
            @config.logger.debug @source.to_s
            ws.close_connection_after_writing
          end
        rescue RuntimeError => e
          EM.run do
            ws = EM::WebSocketClient.connect connection_uri

            ws.callback do 
              ws.send_msg @source.to.json
              ws.close_connection_after_writing
            end

            ws.disconnect do 
              EM::stop_event_loop
            end
          end
        end
      end

      # Dispatch thid applying the TCP strategy
      def tcp port = nil
        if port.nil?
          client = TCPSocket.open @source["resource"].first, @config.port.outbound
        else
          client = TCPSocket.open @source["resource"].first, port
        end

        client.puts @source.to.json
        @config.logger.debug @source.to_s
        client.close
      end

      def json
        Oj.dump @source
      end

      def string 
        response = "#{@source.method} #{@source.resource.join('/')} #{@source.protocol.join('/')}\n"
        @source.each do |key, value|
          unless key == "method" || key == "resource" || key == "protocol" || key == "body"
            if value.is_a? Array
              response += "#{key}: #{value.join('/')}\n"
            else
              response += "#{key}: #{value}\n"
            end
          end
        end

        if @source.body and not @source.body.empty?
          response += "\n"
          if @source.body.is_a? Hash
            @source.body.each do |key, value|
              response += "#{key}: #{Oj.dump(value)}\n"
            end
          else
            response += Oj.dump @source.body
          end
        end
        response
      end

      def short
        unless @source.body
          "#{@source.method} #{@source.resource.join('/')}"
        else
          "#{@source.method} #{@source.resource.join('/')}?#{Oj.dump(@source.body)}"
        end
      end
    end
  end
end