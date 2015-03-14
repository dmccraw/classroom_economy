require 'spec_helper'

describe Account do
  it { is_expected.to belong_to(:owner) }
  it { is_expected.to belong_to(:group) }
  it { is_expected.to have_many(:charges) }

  describe "initial balance" do
    it "should work" do
      teacher = FactoryGirl.create(:user)
      group = FactoryGirl.create(:group, user_id: teacher.id)
      expect(group.store.account.balance).to eq(1000000.0)
    end
  end

end
