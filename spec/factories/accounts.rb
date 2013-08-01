# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :account do
    owner_id nil
    owner_type nil
    group_id nil
    balance 100

    after(:build) do |account|
      account.group = FactoryGirl.create(:group) unless account.group
    end

    factory :store_account do
      association :owner, factory: :store
    end

    factory :user_account do
      association :owner, factory: :user
    end
  end
end
