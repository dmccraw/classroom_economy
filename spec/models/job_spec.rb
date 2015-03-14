require 'spec_helper'

describe Job do
  it { is_expected.to belong_to(:group) }
  it { is_expected.to have_many(:job_assignments) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:salary) }
  it { is_expected.to validate_presence_of(:group_id) }
end
