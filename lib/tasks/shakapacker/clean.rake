$stdout.sync = true

require "shakapacker/configuration"

namespace :shakapacker do
  desc "Remove old compiled webpacks"
  # task :clean, [:keep, :age] => ["shakapacker:verify_install", :environment] do |_, args|
  #   Shakapacker.ensure_log_goes_to_stdout do
  #     Shakapacker.clean(Integer(args.keep || 2), Integer(args.age || 3600))
  #   end
  # end

  task :clean, [:keep, :age] do |_, args|
    $stdout.puts <<~MSG
      #{args.keep}
      #{args.age}
    MSG
  end
end

if Shakapacker.config.webpacker_precompile?
  # Run clean if the assets:clean is run
  if Rake::Task.task_defined?("assets:clean")
    Rake::Task["assets:clean"].enhance do
      Rake::Task["shakapacker:clean"].invoke
    end
  else
    Rake::Task.define_task("assets:clean" => "shakapacker:clean")
  end
end
