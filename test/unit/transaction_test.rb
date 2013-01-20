# == Schema Information
#
# Table name: transactions
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

  should belong_to(:user)
  should have_one(:dispute)

  should validate_presence_of(:from_account_id)
  should validate_presence_of(:to_account_id)
  should validate_presence_of(:amount)
  should validate_numericality_of(:amount)
  should validate_presence_of(:user_id)
  should validate_presence_of(:occurred_on)

end
