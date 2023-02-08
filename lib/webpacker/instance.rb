class Webpacker::Instance < Shakapacker::Instance
  def initialize(root_path: Rails.root, config_path: Rails.root.join("config/webpacker.yml"))
    puts <<~MSG
      \e[33m
      DEPRECATION NOTICE:

      Using Webpacker module is deprecated in Shakapacker. Thought this version offers
      backward compatibility, it is strongly recommended to update your project to comply
      with the future API.

      For more information about this process, check:
      https://github.com/shakacode/shakapacker/docs/webpacker_to_shakapacker_guideline.md
      \e[0m
    MSG

    super
  end

  def env
    @env ||= Webpacker::Env.inquire self
  end

  def config
    # puts "x+x+x+" * 20
    # if @config.blank?
    #   exit 1
    #   puts <<~MSG
    #     \e[33m
    #     DEPRECATION NOTICE:

    #     Using Webpacker module is deprecated in Shakapacker. Thought this version offers
    #     backward compatibility, it is strongly recommended to update your project to comply
    #     with the future API.

    #     For more information about this process, check:
    #     https://github.com/shakacode/shakapacker/docs/webpacker_to_shakapacker_guideline.md
    #     \e[0m
    #   MSG
    # end

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
