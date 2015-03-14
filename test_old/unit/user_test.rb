# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)      not null
#  last_name              :string(255)      not null
#  username               :string(255)      not null
#  user_type              :integer          not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  time_zone              :string(255)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase

  # should have_many(:groups)
  should have_many(:transfers)
  should have_many(:disputes)

  test "valid_email" do
    # make sure if teacher or admin that an email is valid
    user = User.new(first_name: "first", last_name: "last", password: "password", user_type: User::USER_TYPE_ADMIN)
    assert_false user.save

    user = User.new(first_name: "first", last_name: "last", password: "password", user_type: User::USER_TYPE_TEACHER)
    assert_false user.save

    user = User.new(first_name: "first", last_name: "last", password: "password", user_type: User::USER_TYPE_STUDENT)
    assert user.save

  end

  test "stores" do
    # user = FactoryGirl.create(:user)
    # group = FactoryGirl.create(:group, user_id: user.id)

    # store = FactoryGirl.create(:store, group_id: group.id)
    # store_owner = FactoryGirl.create(:store_owner, user_id: user.id, store_id: store.id)
    # # puts user.stores.inspect
    # # puts store.inspect
    # assert_equal(user.stores, [store])
  end

  test "in_group" do
    user = FactoryGirl.create(:user)
    group1 = FactoryGirl.create(:group, user_id: user.id)
    group2 = FactoryGirl.create(:group)
    membership = FactoryGirl.create(:membership, user_id: user.id, group_id: group2.id)
    group3 = FactoryGirl.create(:group)

    assert user.in_group?(group1.id)
    assert user.in_group?(group2.id)
    assert_nil user.in_group?(group3.id)
  end

  test "owns_or_manages_account" do
    group = FactoryGirl.create(:group)
    account = FactoryGirl.create(:user_account, group_id: group.id)
    account2 = FactoryGirl.create(:user_account, group_id: group.id)
    account3 = FactoryGirl.create(:store_account, group_id: group.id)
    store_manager = FactoryGirl.create(:store_manager, store_id: account3.owner.id, user_id: account.owner.id)

    assert_true(account.owner.owns_or_manages_account?(account))
    assert_false(account2.owner.owns_or_manages_account?(account))
    assert_true(account.owner.owns_or_manages_account?(account3))
  end

  test "owns_or_manages_accounts" do
    user = FactoryGirl.create(:user)
    group = FactoryGirl.create(:group)
    FactoryGirl.create(:membership, user_id: user.id, group_id: group.id)
    store = FactoryGirl.create(:store, group_id: group.id)
    store_owner = FactoryGirl.create(:store_owner, user_id: user.id, store_id: store.id)
    user.owns_or_manages_accounts(group.id)
  end

  test "delete teacher" do
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

    teacher.destroy
    assert_equal(Group.count, 0)
    assert_equal(User.count, 0)
    assert_equal(Job.count, 0)
    assert_equal(JobAssignment.count, 0)
    assert_equal(Transfer.count, 0)
    assert_equal(Dispute.count, 0)
    assert_equal(Charge.count, 0)
    assert_equal(Store.count, 0)

  end

  test "delete student" do
    teacher = FactoryGirl.create(:user)
    # create group
    group = FactoryGirl.create(:group, user_id: teacher.id)
    # create student
    student = FactoryGirl.create(:student)
    student2 = FactoryGirl.create(:student)
    membership = FactoryGirl.create(:membership, user_id: student.id, group_id: group.id)
    membership2 = FactoryGirl.create(:membership, user_id: student2.id, group_id: group.id)
    # create job
    job = FactoryGirl.create(:job, group_id: group.id)
    # create job_assignment
    job_assignment = FactoryGirl.create(:job_assignment, job_id: job.id, user_id: student.id, group_id: group.id)
    # charge = FactoryGirl.create(:charge, account_id: student.account(group.id).id, group_id: group.id)
    # create transfer
    transfer = FactoryGirl.create(:transfer, from_account_id: group.store.account.id, to_account_id: student.account(group.id).id, user_id: teacher.id, group_id: group.id)
    # create dispute
    dispute = FactoryGirl.create(:dispute, owner_id: student.id, owner_type: student.class.to_s, transfer_id: transfer.id, group_id: group.id, current_user_id: student.id)

    student.destroy
    assert_equal(Group.count, 1)
    assert_equal(User.count, 2)
    assert_equal(Job.count, 1)
    assert_equal(JobAssignment.count, 0)
    assert_equal(Transfer.count, 0)
    assert_equal(Dispute.count, 0)
    assert_equal(Charge.count, 0)
    assert_equal(Store.count, 1)
  end

  test "bills" do
    teacher = FactoryGirl.create(:user)
    group = FactoryGirl.create(:group, user_id: teacher.id)
    student = FactoryGirl.create(:student)
    membership = FactoryGirl.create(:membership, user_id: student.id, group_id: group.id)

    assert_equal(student.bills(group.id), [])

    bill = FactoryGirl.create(:bill, group_id: group.id, from_account_id: student.account(group.id).id, to_account_id: group.group_account.id)
    assert_equal(student.bills(group.id), [bill])

    bill = FactoryGirl.create(:bill, group_id: group.id, from_account_id: student.account(group.id).id, to_account_id: group.group_account.id)

  end

end
