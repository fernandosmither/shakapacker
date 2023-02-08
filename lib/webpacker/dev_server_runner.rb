require_relative "../shakapacker/dev_server_runner"
require_relative "configuration"
require_relative "dev_server"
require_relative "runner"

module Webpacker
  class DevServerRunner < Shakapacker::DevServerRunner
    private

      def execute_cmd
        env = Webpacker::Compiler.env
        super
      end
  end
end
