
FactoryGirl.define do
  sequence(:email_address) { |n| "email#{n}@example.com" }
end

FactoryGirl.define do
  sequence(:random_email_address) { |n| "user_#{rand(1000000).to_s}@example.com" }
end

FactoryGirl.define do
  sequence(:first_name) { |n| "First_#{n}"}
end

FactoryGirl.define do
  sequence(:last_name) { |n| "Last_#{n}"}
end