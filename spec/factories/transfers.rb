# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transfer do
    from_account nil
    to_account nil
    amount 100.0
    description "MyString"
    occurred_on "2013-01-05 07:24:34"
    user_id nil
    disputed false
    group_id nil

    after(:build) do |transfer|
      unless transfer.from_account_id
        transfer.from_account = FactoryGirl.create(:user_account)
      end
      unless transfer.to_account_id
        transfer.to_account = FactoryGirl.create(:user_account)
      end
      unless transfer.user_id
        transfer.user = FactoryGirl.create(:user)
      end
      unless transfer.group_id
        transfer.group = FactoryGirl.create(:group, user_id: transfer.user_id)
      end
    end
  end
end
