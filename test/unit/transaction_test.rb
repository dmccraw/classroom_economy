# == Schema Information
#
# Table name: transactions
#
#  id           :integer          not null, primary key
#  from_user_id :integer
#  to_user_id   :integer
#  amount       :float
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
