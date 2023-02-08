require "rails/railtie"

require_relative "helper"
require_relative "dev_server_proxy"
require_relative "version_checker"

class Webpacker::Engine < Shakapacker::Engine
  initializer "Webpacker.version_checker" do
    if File.exist?(Webpacker::VersionChecker::NodePackageVersion.package_json_path)
      Webpacker::VersionChecker.build.raise_if_gem_and_node_package_versions_differ
    end
  end

  initializer "Webpacker.proxy" do |app|
    if (Webpacker.config.dev_server.present? rescue nil)
      app.middleware.insert_before 0,
        Rails::VERSION::MAJOR >= 5 ?
          Webpacker::DevServerProxy : "Webpacker::DevServerProxy", ssl_verify_none: true
    end
  end

  initializer "Webpacker.helper" do
    ActiveSupport.on_load :action_controller do
      ActionController::Base.helper Webpacker::Helper
    end

    ActiveSupport.on_load :action_view do
      include Webpacker::Helper
    end
  end

  initializer "Webpacker.logger" do
    config.after_initialize do
      if ::Rails.logger.respond_to?(:tagged)
        Webpacker.logger = ::Rails.logger
      else
        Webpacker.logger = ActiveSupport::TaggedLogging.new(::Rails.logger)
      end
    end
  end

  initializer "Webpacker.bootstrap" do
    if defined?(Rails::Server) || defined?(Rails::Console)
      Webpacker.bootstrap
      if defined?(Spring)
        require "spring/watcher"
        Spring.after_fork { Webpacker.bootstrap }
        Spring.watch(Webpacker.config.config_path)
      end
    end
  end

  initializer "Webpacker.set_source" do |app|
    if Webpacker.config.config_path.exist?
      app.config.javascript_path = Webpacker.config.source_path.relative_path_from(Rails.root.join("app")).to_s
    end
  end

  initializer "Webpacker.remove_app_packs_from_the_autoload_paths" do
    Rails.application.config.before_initialize do
      if Webpacker.config.config_path.exist?
        source_path = Webpacker.config.source_path.to_s
        ActiveSupport::Dependencies.autoload_paths.delete(source_path)
      end
    end
  end
end
