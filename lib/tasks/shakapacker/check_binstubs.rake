namespace :shakapacker do
  desc "Verifies that bin/shakapacker is present"
  task :check_binstubs do
    if File.exist?(Rails.root.join("bin/shakapacker"))
      exit
    elsif File.exist?(Rails.root.join("bin/webpacker"))
      $stderr.puts <<~MSG
        DEPRECATION NOICE:
        `bin/webpacker` found but it is deprecated.
        More info: #{Webpacker::DEPRECATION_GUIDE_URL}
      MSG
    else
      $stderr.puts <<~MSG
        Cound't find shakapacker binstub!
        Possible solutions:
         - Ensure you have run `rails shakapacker:install`.
         - Ensure the `bin` directory and `bin/shakapacker` are not included in .gitignore
      MSG
      exit!
    end
  end
end
