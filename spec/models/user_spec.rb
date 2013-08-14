require 'spec_helper'

describe User do
  it { should have_many(:transactions) }
  it { should have_many(:disputes) }

end
