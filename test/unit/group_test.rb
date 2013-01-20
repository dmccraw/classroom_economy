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

require 'test_helper'

class GroupTest < ActiveSupport::TestCase

  should validate_presence_of(:name)
  should ensure_length_of(:name).is_at_most(255)

  test "test account creation" do
    teacher = FactoryGirl.create(:user)
    group = FactoryGirl.create(:group, user_id: teacher.id)
    assert_not_nil group.store
    puts group.store.inspect
    puts group.store.account.inspect
    # assert_not_nil account = Store.where(owner_id: teacher.id, group_id: group.id).first
    # puts account.inspect

  end
end
