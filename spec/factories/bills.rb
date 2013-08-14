# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bill do
    from_account nil
    to_account nil
    group nil
    user nil
    due_date "2013-03-20 20:42:45"
    amount 1.0
    description "MyString"

    after(:build) do |bill|
      bill.from_account = FactoryGirl.create(:user_account) unless bill.from_account
      bill.to_account = FactoryGirl.create(:user_account) unless bill.to_account
      bill.user = FactoryGirl.create(:user) unless bill.user
      bill.group = FactoryGirl.create(:group, user_id: bill.user.id) unless bill.group
    end

    factory :paid_bill do
      paid true
      paid_date "2013-03-20 20:42:45"
      transaction { FactoryGirl.generate(:transaction, from_account_id: from_account_id, to_account_id: to_account_id)}
    end
  end
end
