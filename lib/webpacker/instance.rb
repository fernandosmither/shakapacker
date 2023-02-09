class Webpacker::Instance < Shakapacker::Instance
  def initialize(root_path: Rails.root, config_path: Rails.root.join("config/webpacker.yml"))
    puts Webpacker::DEPRECATION_MESSAGE

    super
  end

  def env
    @env ||= Webpacker::Env.inquire self
  end

  def config
    @config ||= Webpacker::Configuration.new(
      root_path: root_path,
      config_path: config_path,
      env: env
    )
  end

  def strategy
    @strategy ||= Webpacker::CompilerStrategy.from_config
  end

  def compiler
    @compiler ||= Webpacker::Compiler.new self
  end

  def dev_server
    @dev_server ||= Webpacker::DevServer.new config
  end

  def manifest
    @manifest ||= Webpacker::Manifest.new self
  end

  def commands
    @commands ||= Webpacker::Commands.new self
  end
end
