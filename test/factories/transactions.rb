# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    from_account nil
    to_account nil
    amount 100.0
    description "MyString"
    occurred_on "2013-01-05 07:24:34"
    user_id nil
    disputed false
    group_id nil

    after(:build) do |transaction|
      unless transaction.from_account_id
        transaction.from_account = FactoryGirl.create(:user_account)
      end
      unless transaction.to_account_id
        transaction.to_account = FactoryGirl.create(:user_account)
      end
      unless transaction.user_id
        transaction.user = FactoryGirl.create(:user)
      end
      unless transaction.group_id
        transaction.group = FactoryGirl.create(:group, user_id: transaction.user_id)
      end
    end
  end
end
