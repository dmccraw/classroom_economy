# recreatetest.rb
`bundle exec rake db:drop RAILS_ENV=test --trace`
`bundle exec rake db:create RAILS_ENV=test --trace`
`bundle exec rake db:migrate RAILS_ENV=test --trace`
