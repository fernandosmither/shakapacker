module Shakapacker
  class Runner
    def self.run(argv)
      $stdout.sync = true
      ENV["NODE_ENV"] ||= (ENV["RAILS_ENV"] == "production") ? "production" : "development"
      new(argv).run
    end

    def initialize(argv)
      @argv = argv

      Shakapacker::set_in_env_with_backward_compatibility("SHAKAPACKER_NODE_MODULES_BIN_PATH")
      Shakapacker::set_in_env_with_backward_compatibility("SHAKAPACKER_CONFIG")

      @app_path              = File.expand_path(".", Dir.pwd)
      @node_modules_bin_path = ENV["SHAKAPACKER_NODE_MODULES_BIN_PATH"] || `yarn bin`.chomp
      @webpack_config        = File.join(@app_path, "config/webpack/webpack.config.js")
      @shakapacker_config      = ENV["SHAKAPACKER_CONFIG"] || File.join(@app_path, "config/shakapacker.yml")

      unless File.exist?(@webpack_config)
        $stderr.puts "webpack config #{@webpack_config} not found, please run 'bundle exec rails shakapacker:install' to install Shakapacker with default configs or add the missing config file for your custom environment."
        exit!
      end

      unless File.exist?(@shakapacker_config)
        # for backward compatibility
        deprecated_webpacker_config = File.join(@app_path, "config/webpacker.yml")
        if File.exist?(deprecated_webpacker_config)
          @shakapacker_config = deprecated_webpacker_config
        else
          $stderr.puts "Shakapacker config #{@webpack_config} not found, please run 'bundle exec rails shakapacker:install' to install Shakapacker with default configs or add the missing config file for your custom environment."
          exit!
        end
      end
    end
  end
end
