# == Schema Information
#
# Table name: charges
#
#  id          :integer          not null, primary key
#  account_id  :integer
#  group_id    :integer
#  description :string(255)
#  amount      :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class ChargeTest < ActiveSupport::TestCase

  should validate_presence_of(:account_id)
  should validate_presence_of(:group_id)
  should validate_presence_of(:description)
  should validate_length_of(:description).is_at_most(255)
  should validate_numericality_of(:amount)

end
