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

  test "initial balance" do
    group = FactoryGirl.create(:group)
    puts group.store.inspect
    puts group.store.account.inspect
    assert_equal(group.store.account.balance, 1000000.0)
  end

end
