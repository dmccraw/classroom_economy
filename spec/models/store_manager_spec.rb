require 'spec_helper'

describe StoreManager do
  it { should validate_presence_of :store_id }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :salary }
  it { should validate_numericality_of :salary }
end
