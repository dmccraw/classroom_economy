# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)
#  last_name              :string(255)
#  username               :string(255)
#  user_type              :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase

  should have_many(:groups)
  # should have_many(:transactions)

  test "valid_email" do
    # make sure if teacher or admin that an email is valid
    user = User.new(first_name: "first", last_name: "last", password: "password", user_type: User::USER_TYPE_ADMIN)
    assert_false user.save

    user = User.new(first_name: "first", last_name: "last", password: "password", user_type: User::USER_TYPE_TEACHER)
    assert_false user.save

    user = User.new(first_name: "first", last_name: "last", password: "password", user_type: User::USER_TYPE_STUDENT)
    assert user.save

  end

  test "groups" do

  end

  test "accounts" do
    # teacher = FactoryGirl.create(:)
  end

  test "stores" do
    group = FactoryGirl.create(:group)
    user = FactoryGirl.create(:user)

    store = FactoryGirl.create(:store, group_id: group.id)
    store_owner = FactoryGirl.create(:store_owner, user_id: user.id, store_id: store.id)
    puts user.stores.inspect
    puts store.inspect
    assert user.stores == [store]
  end

end
