namespace :webpacker do
  desc "[DEPRECATED] Provide information on Shakapacker's environment"
  task :info do |task|
    prefix = task.name.split(/#|webpacker:/).first
    Rake::Task["#{prefix}shakapacker:info"].invoke
  end
end
