require 'spec_helper'

describe Transfer do
  it { should belong_to(:user) }
  it { should have_many(:disputes) }

  it { should validate_presence_of(:from_account_id) }
  it { should validate_presence_of(:to_account_id) }
  it { should validate_presence_of(:amount) }
  it { should validate_numericality_of(:amount) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:occurred_on) }

  describe "#undo" do
    it "should undo" do
      transfer = FactoryGirl.create(:transfer)
      expect(transfer.from_account.balance).to eq 0
      expect(transfer.to_account.balance).to eq 200.00
      transfer.undo
      expect(transfer.from_account.balance).to eq 100
      expect(transfer.to_account.balance).to eq 100
    end
  end

end
