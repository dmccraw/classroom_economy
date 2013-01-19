
FactoryGirl.define do
  factory :group do
    name {generate(:group_name)}
    user

    # after(:create) do |group, evaluator|
    #   if group.user_id == nil
    #     group.user_id == FactoryGirl.create(:user).id
    #   end
    # end
  end
end
