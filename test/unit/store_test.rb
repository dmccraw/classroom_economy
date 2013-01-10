# == Schema Information
#
# Table name: stores
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  description :text
#  group_id    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class StoreTest < ActiveSupport::TestCase

  test "create account" do
    store = FactoryGirl.create(:store)
    assert_not_nil store.account
  end
end
