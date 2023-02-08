require_relative "mtime_strategy"
require_relative "digest_strategy"

module Webpacker
  class CompilerStrategy < Shakapacker::CompilerStrategy
    def self.from_config
      strategy_from_config = Webpacker.config.compiler_strategy

      case strategy_from_config
      when "mtime"
        Webpacker::MtimeStrategy.new
      when "digest"
        Webpacker::DigestStrategy.new
      else
        raise "Unknown strategy '#{strategy_from_config}'. " \
              "Available options are 'mtime' and 'digest'."
      end
    end
  end
end
