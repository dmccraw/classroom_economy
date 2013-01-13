# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    owner_id 1
    owner_type ""
    references ""
    balance 1.5
  end
end
