# Call with `rake goodbye`
task :goodbye do
  puts "see you late alligator"
end

# The ruby rocket specifies a dependency. This will run goodbye BEFORE farewell
task :farewell => :goodbye do
  puts "in a while crocodile"
end

# Group things into the namespace `pick`. Call with `rake pick:winner`.
namespace :pick do

  # Document your dasks thusly. These now appear in the list of tasks when you
  # run `rake -T`. Look at a subset of rake tasks with `rake -T pick`.
  desc "Pick a random user as the winner."

  # Rails does not automatically load rails environment which would cause User
  # not to be found. Thus we specify it as a dependency.
  task :winner => :environment do
    user = User.find(:first, :order => 'RAND()')
    puts "Winner: #{user.name}"
  end

  desc "Pick a random product as the prize."
  task :prize => :environment do
    # Use methods to DRY out your code as normal.
    puts "Prize: #{pick_random(Product)}"
  end

  desc "Pick a random prize and winner."
  # Supply multiple dependencies. You don't need to supply a block in this case.
  # This will run the depencies in the order specified
  task :all => [:prize, :winner] 

  def pick_random(model_class)
    model_class.find(:first, :order => 'RAND()')
  end

end