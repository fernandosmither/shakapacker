require "open3"
require_relative "compiler_strategy"

class Shakapacker::Compiler
  # Additional environment variables that the compiler is being run with
  # Shakapacker::Compiler.env['FRONTEND_API_KEY'] = 'your_secret_key'
  cattr_accessor(:env) { {} }

  delegate :config, :logger, :strategy, to: :shakapacker
  delegate :fresh?, :stale?, :after_compile_hook, to: :strategy

  def initialize(shakapacker)
    @shakapacker = shakapacker
  end

  def compile
    unless stale?
      logger.debug "Everything's up-to-date. Nothing to do"
      return true
    end

    if compiling?
      wait_for_compilation_to_complete
      true
    else
      acquire_ipc_lock do
        run_webpack.tap do |success|
          after_compile_hook
        end
      end
    end
  end

  private
    attr_reader :shakapacker

    def acquire_ipc_lock
      open_lock_file do |lf|
        lf.flock(File::LOCK_EX)
        yield if block_given?
      end
    end

    def locked?
      open_lock_file do |lf|
        lf.flock(File::LOCK_EX | File::LOCK_NB) != 0
      end
    end

    alias compiling? locked?

    def wait_for_compilation_to_complete
      logger.info "Waiting for the compilation to complete..."
      acquire_ipc_lock
    end

    def open_lock_file
      lock_file_name = File.join(Dir.tmpdir, "shakapacker.lock")
      File.open(lock_file_name, File::CREAT) do |lf|
        return yield lf
      end
    end

    def optionalRubyRunner
      bin_shakapacker_path = config.root_path.join("bin/shakapacker")

      # for backward compatibility
      unless File.exist?(bin_shakapacker_path)
        bin_shakapacker_path = config.root_path.join("bin/webpacker")
      end

      first_line = File.readlines(bin_shakapacker_path).first.chomp
      /ruby/.match?(first_line) ? RbConfig.ruby : ""
    end

    def run_webpack
      logger.info "Compiling..."

      stdout, stderr, status = Open3.capture3(
        webpack_env,
        "#{optionalRubyRunner} ./bin/shakapacker",
        chdir: File.expand_path(config.root_path)
      )

      if status.success?
        logger.info "Compiled all packs in #{config.public_output_path}"
        logger.error "#{stderr}" unless stderr.empty?

        if config.webpack_compile_output?
          logger.info stdout
        end
      else
        non_empty_streams = [stdout, stderr].delete_if(&:empty?)
        logger.error "\nCOMPILATION FAILED:\nEXIT STATUS: #{status}\nOUTPUTS:\n#{non_empty_streams.join("\n\n")}"
      end

      status.success?
    end

    def webpack_env
      return env unless defined?(ActionController::Base)

      Shakapacker::set_in_env_with_backward_compatibility("SHAKAPACKER_ASSET_HOST")
      Shakapacker::set_in_env_with_backward_compatibility("SHAKAPACKER_RELATIVE_URL_ROOT")

      env.merge(
        "SHAKAPACKER_ASSET_HOST"        => ENV.fetch("SHAKAPACKER_ASSET_HOST", ActionController::Base.helpers.compute_asset_host),
        "WEBPACKER_ASSET_HOST"          => ENV.fetch("SHAKAPACKER_ASSET_HOST", ActionController::Base.helpers.compute_asset_host),
        "SHAKAPACKER_RELATIVE_URL_ROOT" => ENV.fetch("SHAKAPACKER_RELATIVE_URL_ROOT", ActionController::Base.relative_url_root),
        "WEBPACKER_RELATIVE_URL_ROOT"   => ENV.fetch("SHAKAPACKER_RELATIVE_URL_ROOT", ActionController::Base.relative_url_root),
        "SHAKAPACKER_CONFIG" => shakapacker.config_path.to_s,
        "WEBPACKER_CONFIG"   => shakapacker.config_path.to_s
      )
    end
end
