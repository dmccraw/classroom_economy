# == Schema Information
#
# Table name: store_managers
#
#  id           :integer          not null, primary key
#  store_id     :integer
#  user_id      :integer
#  manage_level :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class StoreManagerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
