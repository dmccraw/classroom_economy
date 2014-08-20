require 'spec_helper'

describe Bill do
  context "associations" do
    it { should belong_to(:group) }
    it { should belong_to(:user) }
    it { should belong_to(:transfer) }
  end

  context "validations" do
    it { should validate_presence_of(:from_account_id) }
    it { should validate_presence_of(:to_account_id) }
    it { should validate_presence_of(:group_id) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:due_date) }
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount) }
    it { should validate_presence_of(:description) }
    it { should ensure_length_of(:description).is_at_least(3).is_at_most(255) }
  end

  context "#pay" do
    it "should work" do
      bill = FactoryGirl.create(:bill)
      expect(bill.pay(bill.user)).to eq(true)
    end
  end
end
