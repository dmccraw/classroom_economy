require 'spec_helper'

describe User do
  it { should have_many(:transfers) }
  it { should have_many(:disputes) }

end
