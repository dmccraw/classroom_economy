require 'spec_helper'

describe StoreManager, :type => :model do
  it { is_expected.to validate_presence_of :store_id }
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :salary }
  it { is_expected.to validate_numericality_of :salary }
end
