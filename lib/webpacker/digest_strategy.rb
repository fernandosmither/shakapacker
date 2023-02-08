require "digest/sha1"
require_relative "base_strategy"

module Webpacker
  class DigestStrategy < Shakapacker::DigestStrategy
    private

      def compilation_digest_path
        config.cache_path.join("last-compilation-digest-#{Webpacker.env}")
      end
  end
end
