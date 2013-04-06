module Writer
  module JSTP
    class Dispatch < Discoverer::Pattern
      attr_accessor :pool

      def initialize source
        super source
        @config = ::JSTP::Configuration.instance
        @pool = {}
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
              @config.logger.debug @source.to_s
              ws.close_connection_after_writing
            end

            ws.disconnect do 
              EM::stop_event_loop
            end
          end
        end
      end

      # Dispatch applying the TCP strategy
      def tcp port = nil
        port = @config.port.outbound if port.nil?
        host = @source['resource'].first

        @pool[host] ||= TCPSocket.new host, port

        if @pool[host].closed?
          @pool[host] = TCPSocket.new host, port
        elsif not @pool[host].stat.readable?
          @pool[host].close
          @pool[host] = TCPSocket.new host, port
        end

        @pool[host].puts @source.to.json
        @config.logger.debug @source.to_s
      end

      def json
        JSON.dump @source
      end

      def string 
        response = "#{@source.method} #{@source.resource.join('/')} #{@source.protocol.join('/')}\n"
        @source.each do |key, value|
          unless key == "method" || key == "resource" || key == "protocol" || key == "body"
            if value.is_a? Array
              response += "#{key}: #{value.join('/')}\n"
            else
              if key == 'timestamp'
                response += "#{key}: #{Time.at(value)}\n"
              else
                response += "#{key}: #{value}\n"
              end
            end
          end
        end

        unless @source.body.nil?
          response += "\n"
          if @source.body.is_a? Hash
            @source.body.each do |key, value|
              begin
                response += "#{key}: #{JSON.dump(value)}\n"
              rescue JSON::GeneratorError => e 
                response += "#{key}: #{value}\n"
              end
            end
          else
            response += JSON.dump @source.body
          end
        end
        response
      end

      def short
        unless @source.body
          "#{@source.method} #{@source.resource.join('/')}"
        else
          "#{@source.method} #{@source.resource.join('/')}?#{JSON.dump(@source.body)}"
        end
      end
    end
  end
end
