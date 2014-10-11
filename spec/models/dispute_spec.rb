require 'spec_helper'

describe Dispute do
  context "associations" do
    it { should belong_to :transfer }
    it { should belong_to :group }
    it { should belong_to :owner }
    it { should belong_to :result_transfer }
  end

  context "validations" do
    it { should validate_presence_of(:owner_id) }
    it { should validate_presence_of(:owner_type) }
    it { should validate_presence_of(:transfer_id) }
    it { should validate_presence_of(:group_id) }
    it { should validate_presence_of(:reason) }
    it { should ensure_length_of(:owner_type).is_at_most(255) }
    it { should ensure_length_of(:reason).is_at_most(255) }
    it { should ensure_length_of(:result_reason).is_at_most(255) }
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
