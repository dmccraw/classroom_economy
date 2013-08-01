require 'spec_helper'

describe Charge do
  context "validations" do
    it { should validate_presence_of(:account_id) }
    it { should validate_presence_of(:group_id) }
    it { should validate_presence_of(:description) }
    it { should ensure_length_of(:description).is_at_most(255) }
    it { should validate_numericality_of(:amount) }
  end
end
