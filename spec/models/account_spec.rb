require 'spec_helper'

describe Account do
  context "associations" do
    it { is_expected.to belong_to(:owner) }
    it { is_expected.to belong_to(:group) }
    it { is_expected.to have_many(:charges) }
  end

  context "validations" do
    it { is_expected.to validate_presence_of(:owner_id) }
    it { is_expected.to validate_presence_of(:owner_type) }
    it { is_expected.to validate_presence_of(:group_id) }
    it { is_expected.to validate_presence_of(:balance) }
  end

  context ".initial balance" do
    it "should work" do
      teacher = FactoryGirl.create(:user)
      group = FactoryGirl.create(:group, user_id: teacher.id)
      expect(group.store.account.balance).to eq(1000000.0)
    end
  end

  context "description" do

  end

end
