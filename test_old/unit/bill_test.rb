# == Schema Information
#
# Table name: bills
#
#  id              :integer          not null, primary key
#  from_account_id :integer
#  to_account_id   :integer
#  group_id        :integer
#  user_id         :integer
#  due_date        :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  paid            :boolean
#  paid_date       :datetime
#  transfer_id  :integer
#  amount          :float
#  description     :string(255)
#

require 'test_helper'

class BillTest < ActiveSupport::TestCase
  # should belong_to(:from_account)

  should belong_to(:group)
  should belong_to(:user)
  should belong_to(:transfer)

  should validate_presence_of(:from_account_id)
  should validate_presence_of(:to_account_id)
  should validate_presence_of(:group_id)
  should validate_presence_of(:user_id)
  should validate_presence_of(:due_date)
  should validate_presence_of(:amount)
  should validate_numericality_of(:amount)
  should validate_presence_of(:description)
  should validate_length_of(:description).is_at_least(3).is_at_most(255)

  test "should pay bill" do
    bill = FactoryGirl.create(:bill)
    assert_equal(bill.pay(bill.user), true)
  end
end
