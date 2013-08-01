require 'spec_helper'

describe Job do
  it { should belong_to(:group) }
  it { should have_many(:job_assignments) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:salary) }
  it { should validate_presence_of(:group_id) }
end
