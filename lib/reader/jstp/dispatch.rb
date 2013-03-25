# http://www.youtube.com/watch?v=pXPzZezGu8k
module Reader
  module JSTP
    class Dispatch < Discoverer::Pattern
      def hash the_hash
        the_hash.each do |key, value|
          @source[key] = value
        end
        
        @source
      end

      # Actually, is JSON
      def string the_string
        JSON.load(the_string).each do |key, value|
          @source[key] = value
        end

        @source
      end

      def array the_array
        @source.method = the_array.first if the_array.first
        @source.resource = the_array[1] if the_array[1]
        @source.body = the_array[2] if the_array[2]
        if the_array[3]
          the_array[3].each do |key, value|
            @source[key] = value
          end
        end 

        @source
      end
    end
  end
end