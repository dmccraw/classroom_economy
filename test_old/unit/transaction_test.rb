# == Schema Information
#
# Table name: transfers
#
#  id              :integer          not null, primary key
#  from_account_id :integer          not null
#  to_account_id   :integer          not null
#  group_id        :integer          not null
#  amount          :float            not null
#  description     :string(255)      not null
#  occurred_on     :datetime         not null
#  user_id         :integer          not null
#  disputed        :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class TransactionTest < ActiveSupport::TestCase

  # should belong_to(:user)
  # should have_many(:disputes)

  # should validate_presence_of(:from_account_id)
  # should validate_presence_of(:to_account_id)
  # should validate_presence_of(:amount)
  # should validate_numericality_of(:amount)
  # should validate_presence_of(:user_id)
  # should validate_presence_of(:occurred_on)

  test "should undo" do
    transfer = FactoryGirl.create(:transfer)
    assert_equal transfer.from_account.balance, 0
    assert_equal transfer.to_account.balance, 200.00
    transfer.undo
    assert_equal transfer.from_account.balance, 100
    assert_equal transfer.to_account.balance, 100
  end

end
