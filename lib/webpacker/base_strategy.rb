module Webpacker
  class BaseStrategy < Shakapacker::BaseStrategy
    def initialize
      @config = Webpacker.config
    end
  end
end
