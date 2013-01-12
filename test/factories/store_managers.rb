# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :store_manager do
    store_id nil
    user_id nil
    manage_level 1
  end
end
