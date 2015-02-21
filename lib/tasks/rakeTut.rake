# http://jasonseifer.com/2010/04/06/rake-tutorial

directory 'tmp'

file "tmp/hello.tmp" => "tmp" do
  sh "echo 'Hello' > 'tmp/hello.tmp'"
end

namespace :morning do
  # This can be invoked with args as: `rake COFFEE_CUPS=5 make_coffee`
  task :make_coffee do
    cups = ENV["COFFEE_CUPS"] || 2
    puts "Made #{cups} cups of coffee."
  end
end

namespace :morning do
  # This ADDS to :make_coffee.
  task :make_coffee do
    puts "That was refreshing!"
  end
end

namespace :afternoon do
  task :make_coffee do
    # Invoke a rake task from within another rake.
    Rake::Task['morning:make_coffee'].invoke
    puts "Ready for the rest of the day"
  end
end

# Sets the default rake result (run `rake`) to this task
task :default => 'morning:make_coffee'