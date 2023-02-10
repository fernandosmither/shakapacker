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

  DEPRECATION_GUIDE_URL = "https://github.com/shakacode/shakapacker/docs/v7_upgrade.md"
  DEPRECATION_MESSAGE = <<~MSG
    \e[33m
    DEPRECATION NOTICE:

    Using Webpacker module is deprecated in Shakapacker. Thought this version
    offers backward compatibility, it is strongly recommended to update your
    project to comply with the new interfaces.

    For more information about this process, check:
    #{DEPRECATION_GUIDE_URL}
    \e[0m
  MSG
end

require_relative "webpacker/instance"
require_relative "webpacker/env"
require_relative "webpacker/configuration"
require_relative "webpacker/manifest"
require_relative "webpacker/compiler"
require_relative "webpacker/commands"
require_relative "webpacker/dev_server"

require_relative "webpacker/railtie" if defined?(Rails)
