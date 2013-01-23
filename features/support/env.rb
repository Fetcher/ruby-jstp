$LOAD_PATH << File.expand_path("../../../lib", __FILE__)

require 'jstp'

module Testing
  def self.test_log
    @test_log ||= []
  end
end

World Testing
