module JSTP
  class Dispatch < Hash
    include Discoverer::Writer
    include Discoverer::Reader
    
    def initialize *args
      
      unless args.empty?
        if args.length == 1
          if args.first.is_a? Hash
            from.hash args.first
          elsif args.first.is_a? String
            from.string args.first
          elsif args.first.is_a? Symbol
            self.method = args.first
          end
        else
          from.array args
        end
      end

      self["protocol"] = ["JSTP", "0.1"] unless self.has_key? "protocol"
      self["timestamp"] = Time.now.to_i
    end

    def to_s
      to.string
    end

    def method
      self["method"]
    end

    def method= the_method
      self["method"] = the_method.to_s.upcase
    end

    def resource
      self["resource"]
    end

    def resource= the_resource
      if the_resource.is_a? Array
        self["resource"] = the_resource
      elsif the_resource.is_a? String
        self["resource"] = the_resource.split "/"
      end
    end

    def protocol
      self["protocol"]
    end

    def protocol= the_protocol
      if the_protocol.is_a? Array
        self["protocol"] = the_protocol
      elsif the_protocol.is_a? String 
        self["protocol"] = the_protocol.split "/"
      end
    end

    def timestamp
      self["timestamp"]
    end

    def timestamp= the_timestamp
      if the_timestamp.is_a? Integer
        self["timestamp"] = the_timestamp
      elsif the_timestamp.is_a? Time
        self["timestamp"] = the_timestamp.to_i
      end
    end

    def referer
      self["referer"]
    end

    def referer= the_referer
      if the_referer.is_a? Array
        self["referer"] = the_referer
      elsif the_referer.is_a? String 
        self["referer"] = the_referer.split "/"
      end
    end

    def token
      self["token"]
    end

    def token= the_token
      if the_token.is_a? Array
        self["token"] = the_token
      elsif the_token.is_a? String 
        self["token"] = the_token.split "/"
      end
    end     

    def body
      self["body"]
    end

    def body= the_body
      self["body"] = the_body
    end

    def gateway
      self["gateway"]
    end

    def gateway= the_gateway
      self["gateway"] = the_gateway
    end
  end
end