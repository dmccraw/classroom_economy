# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :dispute do
    owner_id nil
    owner_type nil
    transfer_id nil
    group_id nil
    reason "MyString"
    result 1
    result_reason "MyString"
    result_transfer_id nil
    current_user_id nil

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
        unless dispute.transfer_id
          dispute.transfer = FactoryGirl.create(:transfer)
        end
        unless dispute.current_user_id
          dispute.current_user_id = FactoryGirl.create(:user).id
        end
      }
    end

    factory :store_dispute do
    end
  end
end
