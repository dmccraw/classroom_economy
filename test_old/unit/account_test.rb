# == Schema Information
#
# Table name: accounts
#
#  id         :integer          not null, primary key
#  owner_id   :integer
#  owner_type :string(255)
#  group_id   :integer
#  balance    :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class AccountTest < ActiveSupport::TestCase

  should belong_to(:owner)
  should belong_to(:group)
  should have_many(:charges)

  test "initial balance" do
    teacher = FactoryGirl.create(:user)
    group = FactoryGirl.create(:group, user_id: teacher.id)
    assert_equal(group.store.account.balance, 1000000.0)
  end

end
