require "active_support/core_ext/module/attribute_accessors"
require "active_support/core_ext/string/inquiry"
require "active_support/logger"
require "active_support/tagged_logging"

require_relative "./shakapacker"

module Webpacker
  extend self

  extend Shakapacker

  DEFAULT_ENV = "production".freeze

  def instance
    @instance ||= Webpacker::Instance.new
  end

  def ensure_log_goes_to_stdout
    old_logger = Webpacker.logger
    Webpacker.logger = Logger.new(STDOUT)
    yield
  ensure
    Webpacker.logger = old_logger
  end
end

require_relative "webpacker/instance"
require_relative "webpacker/env"
require_relative "webpacker/configuration"
require_relative "webpacker/manifest"
require_relative "webpacker/compiler"
require_relative "webpacker/commands"
require_relative "webpacker/dev_server"

require_relative "webpacker/railtie" if defined?(Rails)
