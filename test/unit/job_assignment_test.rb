# == Schema Information
#
# Table name: job_assignments
#
#  id         :integer          not null, primary key
#  job_id     :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class JobAssignmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
