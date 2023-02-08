# require "yaml"
# require "active_support/core_ext/hash/keys"
# require "active_support/core_ext/hash/indifferent_access"

class Webpacker::Configuration < Shakapacker::Configuration
  private
    def defaults
      @defaults ||= begin
        path = File.expand_path("../../install/config/webpacker.yml", __FILE__)
        config = begin
          YAML.load_file(path, aliases: true)
        rescue ArgumentError
          YAML.load_file(path)
        end
        HashWithIndifferentAccess.new(config[env] || config[Webpacker::DEFAULT_ENV])
      end
    end
end
