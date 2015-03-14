require 'spec_helper'

describe Dispute do
  context "associations" do
    it { is_expected.to belong_to :transfer }
    it { is_expected.to belong_to :group }
    it { is_expected.to belong_to :owner }
    it { is_expected.to belong_to :result_transfer }
  end

  context "validations" do
    it { is_expected.to validate_presence_of(:owner_id) }
    it { is_expected.to validate_presence_of(:owner_type) }
    it { is_expected.to validate_presence_of(:transfer_id) }
    it { is_expected.to validate_presence_of(:group_id) }
    it { is_expected.to validate_presence_of(:reason) }
    it { is_expected.to ensure_length_of(:owner_type).is_at_most(255) }
    it { is_expected.to ensure_length_of(:reason).is_at_most(255) }
    it { is_expected.to ensure_length_of(:result_reason).is_at_most(255) }
  end

  context "transfer_funds" do
    it "should transfer_funds" do
      dispute = FactoryGirl.create(:user_dispute)
      dispute.result = Dispute::APPROVE
      dispute.result_reason = "Test"
      dispute.current_user_id = FactoryGirl.create(:user).id
      expect(dispute.save).to eq(true)
      # expect(dispute.result_transfer).to eq(true)
    end
  end
end
