# == Schema Information
#
# Table name: disputes
#
#  id                    :integer          not null, primary key
#  owner_id              :integer
#  owner_type            :string(255)
#  transfer_id        :integer
#  group_id              :integer
#  reason                :text
#  result                :integer
#  result_reason         :text
#  result_transfer_id :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'test_helper'

class DisputeTest < ActiveSupport::TestCase
  should belong_to :transfer
  should belong_to :group
  should belong_to :owner
  should belong_to :result_transfer

  should validate_presence_of(:owner_id)
  should validate_presence_of(:owner_type)
  should validate_presence_of(:transfer_id)
  should validate_presence_of(:group_id)
  should validate_presence_of(:reason)
  should validate_length_of(:owner_type).is_at_most(255)
  should validate_length_of(:reason).is_at_most(255)
  should validate_length_of(:result_reason).is_at_most(255)

  test "should transfer_funds" do
    dispute = FactoryGirl.create(:user_dispute)
    dispute.result = Dispute::APPROVE
    dispute.result_reason = "Test"
    dispute.current_user_id = FactoryGirl.create(:user).id
    assert dispute.save
    assert dispute.result_transfer
  end

end
