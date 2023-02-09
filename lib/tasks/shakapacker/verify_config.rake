require "shakapacker/configuration"

namespace :shakapacker do
  desc "Verifies if the Shakapacker config is present"
  task :verify_config do
    path = Shakapacker.config.config_path.relative_path_from(Pathname.new(pwd)).to_s

    unless Shakapacker.config.config_path.exist?
      $stderr.puts <<~MSG
        Configuration `#{path}` file not found.
        Make sure shakapacker:install is run successfully before
        running dependent tasks
      MSG
      exit!
    end

    if Shakapacker.config.config_path.to_s.end_with?("webpacker.yml")
      $stderr.puts <<~MSG
        DEPRECATION NOICE:
        Configuration `#{path}` file is deprecated.
        More info: FIXME
      MSG
    end
  end
end
