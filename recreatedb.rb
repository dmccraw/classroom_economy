#!/usr/bin/ruby
puts "Dropping db..."
`bundle exec rake db:drop --trace`

puts "Creating db..."
`bundle exec rake db:create --trace`

puts "Migrating db..."
`bundle exec rake db:migrate --trace`

puts "Seeding db..."
`bundle exec rake db:seed --trace`
