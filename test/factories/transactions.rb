# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    from_account nil
    to_account nil
    amount ""
    description "MyString"
    occurred_on "2013-01-05 07:24:34"
    user nil
    disputed false
  end
end
