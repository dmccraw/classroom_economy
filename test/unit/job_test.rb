# == Schema Information
#
# Table name: jobs
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :string(255)
#  salary      :float
#  group_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class JobTest < ActiveSupport::TestCase
  should belong_to(:group)
  should have_many(:job_assignments)

  should validate_presence_of(:title)
  should validate_presence_of(:description)
  should validate_presence_of(:salary)
  should validate_presence_of(:group_id)
end
