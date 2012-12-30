# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    from_user { FactoryGirl.create(:user) }
    to_user { FactoryGirl.create(:user) }
    amount 1.5
    description "MyText"
  end
end
