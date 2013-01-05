module JSTP
  module API
    def dispatch &block
      JSTP::Registry.instance.set block

      ::EventMachine.run &JSTP::EventMachine
    end
  end
end