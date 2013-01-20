# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :dispute do
    owner_id nil
    owner_type nil
    transaction_id nil
    group_id nil
    reason "MyString"
    result 1
    result_reason "MyString"

    factory :user_dispute do
      after(:build) { |dispute|
        unless dispute.owner_id
          user = FactoryGirl.create(:user)
          dispute.owner_id = user.id
          dispute.owner_type = user.class.to_s
        end
        unless dispute.group_id
          dispute.group = FactoryGirl.create(:group, user_id: user.id)
        end
        unless dispute.transaction_id
          dispute.transaction = FactoryGirl.create(:transaction)
        end
      }
    end

    factory :store_dispute do
    end
  end
end
