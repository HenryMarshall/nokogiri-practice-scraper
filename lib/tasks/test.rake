task :test_rake => :environment do
  puts Article.test_method
end

task :get_sports_articles => :environment do
  puts Article.get_sports_articles
end