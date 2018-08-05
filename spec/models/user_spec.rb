require 'spec_helper'

describe User do
  it { is_expected.to have_many(:transfers) }
  it { is_expected.to have_many(:disputes) }

end
