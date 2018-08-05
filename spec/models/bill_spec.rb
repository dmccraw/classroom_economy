require 'spec_helper'

describe Bill do
  context "associations" do
    it { is_expected.to belong_to(:group) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:transfer) }
  end

  context "validations" do
    it { is_expected.to validate_presence_of(:from_account_id) }
    it { is_expected.to validate_presence_of(:to_account_id) }
    it { is_expected.to validate_presence_of(:group_id) }
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:due_date) }
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_numericality_of(:amount) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to ensure_length_of(:description).is_at_least(3).is_at_most(255) }
  end

  context "#pay" do
    it "should work" do
      bill = FactoryGirl.create(:bill)
      expect(bill.pay(bill.user)).to eq(true)
    end
  end
end
