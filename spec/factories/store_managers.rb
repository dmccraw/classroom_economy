# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :store_manager do
    store
    user
    manage_level 1
    salary 0.0
  end
end
