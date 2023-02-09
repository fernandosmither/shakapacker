namespace :webpacker do
  desc "[DEPRECATED] Remove old compiled webpacks"
  task :clean, [:keep, :age] do |_, args|
    prefix = task.name.split(/#|webpacker:/).first
    Rake::Task["#{prefix}shakapacker:clean"].invoke(args.keep, args.age)
  end
end
