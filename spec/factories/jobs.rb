# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :job do
    title "My Job"
    description "MyString"
    salary "1.0"
    group_id nil
  end
end
