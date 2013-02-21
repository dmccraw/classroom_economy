# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :charge do
    account_id nil
    group_id nil
    description "MyText"
    amount 1.0

    # after(:build) do |charge|
    #   unless charge.account_id
    #     charge.user_id = FactoryGirl.create(:user).id
    #   end
    #   unless charge.group_id
    #     charge.group_id = FactoryGirl.create(:group).id
    #   end
    # end
  end
end
