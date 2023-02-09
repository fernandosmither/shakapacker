tasks = {
  "webpacker:info"                    => "[DEPRECATED] Provides information on Webpacker's environment",
  "webpacker:install"                 => "[DEPRECATED] Installs and setup webpack with Yarn",
  "webpacker:compile"                 => "[DEPRECATED] Compiles webpack bundles based on environment",
  "webpacker:clean"                   => "[DEPRECATED] Remove old compiled webpacks",
  "webpacker:clobber"                 => "[DEPRECATED] Removes the webpack compiled output directory",
  "webpacker:check_node"              => "[DEPRECATED] Verifies if Node.js is installed",
  "webpacker:check_yarn"              => "[DEPRECATED] Verifies if Yarn is installed",
  "webpacker:check_binstubs"          => "[DEPRECATED] Verifies that bin/webpacker is present",
  "webpacker:binstubs"                => "[DEPRECATED] Installs Webpacker binstubs in this application",
  "webpacker:verify_install"          => "[DEPRECATED] Verifies if Webpacker is installed",
}.freeze

desc "Lists all available tasks in Webpacker"
task :webpacker do
  puts "Available Webpacker tasks are:"
  tasks.each { |task, message| puts task.ljust(30) + message }
  puts "NOTICE: Use of Webpacker is deprecated. Cosider using Shakapacker tasks."
  puts "More information: rake shakapacker"
end
