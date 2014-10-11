require 'spec_helper'

describe Group, :type => :model do
  context "associations" do
    it { is_expected.to have_many(:charges) }
    it { is_expected.to have_many(:users) }
    it { is_expected.to have_many(:accounts) }
    it { is_expected.to have_many(:jobs) }
    it { is_expected.to have_many(:job_assignments) }
    it { is_expected.to have_many(:transfers) }
    it { is_expected.to have_many(:disputes) }
    it { is_expected.to have_many(:stores) }
  end

  context "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to ensure_length_of(:name).is_at_most(255) }
  end

  describe "test account creation" do
    it "should work" do
      teacher = FactoryGirl.create(:user)
      group = FactoryGirl.create(:group, user_id: teacher.id)
      expect(group.store).to_not eq(nil)
      puts group.store.inspect
      puts group.store.account.inspect
      # assert_not_nil account = Store.where(owner_id: teacher.id, group_id: group.id).first
      # puts account.inspect
    end
  end

  describe "group delete" do
    it "group delete" do
      # create teacher
      teacher = FactoryGirl.create(:user)
      # create group
      group = FactoryGirl.create(:group, user_id: teacher.id)
      # create student
      student = FactoryGirl.create(:student)
      membership = FactoryGirl.create(:membership, user_id: student.id, group_id: group.id)
      # create job
      job = FactoryGirl.create(:job, group_id: group.id)
      # create job_assignment
      job_assignment = FactoryGirl.create(:job_assignment, job_id: job.id, user_id: student.id, group_id: group.id)
      # charge = FactoryGirl.create(:charge, account_id: student.account(group.id).id, group_id: group.id)
      # create transfer
      transfer = FactoryGirl.create(:transfer, from_account_id: group.store.account.id, to_account_id: student.account(group.id).id, user_id: teacher.id, group_id: group.id)
      # create dispute
      dispute = FactoryGirl.create(:dispute, owner_id: student.id, owner_type: student.class.to_s, transfer_id: transfer.id, group_id: group.id, current_user_id: student.id)

      group.destroy
      expect(Group.count).to eq(0)
      expect(User.count).to eq(1)
      expect(Job.count).to eq(0)
      expect(JobAssignment.count).to eq(0)
      expect(Transaction.count).to eq(0)
      expect(Dispute.count).to eq(0)
      expect(Charge.count).to eq(0)
      expect(Store.count).to eq(0)
    end
  end

end
