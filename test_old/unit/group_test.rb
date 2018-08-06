# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class GroupTest < ActiveSupport::TestCase

  should validate_presence_of(:name)
  should validate_length_of(:name).is_at_most(255)

  should have_many(:charges)
  should have_many(:users)
  should have_many(:accounts)
  should have_many(:jobs)
  should have_many(:job_assignments)
  should have_many(:transfers)
  should have_many(:disputes)
  should have_many(:stores)

  test "test account creation" do
    teacher = FactoryGirl.create(:user)
    group = FactoryGirl.create(:group, user_id: teacher.id)
    assert_not_nil group.store
    puts group.store.inspect
    puts group.store.account.inspect
    # assert_not_nil account = Store.where(owner_id: teacher.id, group_id: group.id).first
    # puts account.inspect
  end

  test "group delete" do
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
    assert_equal(Group.count, 0)
    assert_equal(User.count, 1)
    assert_equal(Job.count, 0)
    assert_equal(JobAssignment.count, 0)
    assert_equal(Transfer.count, 0)
    assert_equal(Dispute.count, 0)
    assert_equal(Charge.count, 0)
    assert_equal(Store.count, 0)
  end
end
