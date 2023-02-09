require "shakapacker/version"

namespace :shakapacker do
  desc "Provide information on Shakapackers's environment"
  task :info do
    Dir.chdir(Rails.root) do
      $stdout.puts <<~INFO
        Ruby: #{`ruby --version`.chomp}
        Rails: #{Rails.version}
        Shakapacker: #{Shakapacker::VERSION}
        Node: #{`node --version`.chomp}
        Yarn: #{`yarn --version`.chomp}

        shakapacker:
        #{`npm list shakapacker version`.chomp}
        Is bin/shakapacker present?: #{bin_shakapacker_exists}
        Is bin/shakapacker-dev-server present?: #{bin_shakapacker_dev_server_exists}
        Is bin/yarn present?: #{File.exist? 'bin/yarn'}
      INFO
    end
  end
end

def bin_shakapacker_exists
  return "Yes" if File.exist?("bin/shakapacker")
  return "No! but deprecated `bin/webpacker` exist." if File.exist?("bin/webpacker")

  "No!"
end

def bin_shakapacker_dev_server_exists
  return "Yes" if File.exist?("bin/shakapacker-dev-server")
  return "No! but deprecated `bin/webpacker-dev-server` exist." if File.exist?("bin/webpacker-dev-server")

  "No!"
end
