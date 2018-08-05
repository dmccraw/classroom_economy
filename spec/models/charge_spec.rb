require 'spec_helper'

describe Charge do
  context "validations" do
    it { is_expected.to validate_presence_of(:account_id) }
    it { is_expected.to validate_presence_of(:group_id) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to ensure_length_of(:description).is_at_most(255) }
    it { is_expected.to validate_numericality_of(:amount) }
  end
end
