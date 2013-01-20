# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :group do
    name {generate(:group_name)}
    user_id = nil
    # user

    before(:create) { |group|
      if group.user_id == nil
        group.user_id = FactoryGirl.create(:user).id
      end
    }
    # after(:create) do |group, evaluator|
    #   if group.user_id == nil
    #     group.user_id == FactoryGirl.create(:user).id
    #   end
    # end
  end
end
