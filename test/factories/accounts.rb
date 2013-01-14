# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :account do
    owner_id 1
    owner_type ""
    group_id nil
    balance 1.5

    factory :store_account do
      association :owner, factory: :store
    end

    factory :user_account do
      association :owner, factory: :user
    end

  end
end
