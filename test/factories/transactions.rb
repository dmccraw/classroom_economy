# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    from_id nil
    to_id nil
    amount 1.5
    description "MyText"
  end
end
