require 'spec_helper'

describe Store, :type => :model do
  it "create account" do
    store = FactoryGirl.create(:store)
    expect(store.account).to_not be(nil)
  end
end
