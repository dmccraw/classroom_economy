# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)      not null
#  last_name              :string(255)      not null
#  username               :string(255)      not null
#  user_type              :integer          not null
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

  test "stores" do
    user = FactoryGirl.create(:user)
    group = FactoryGirl.create(:group, user_id: user.id)

    store = FactoryGirl.create(:store, group_id: group.id)
    store_owner = FactoryGirl.create(:store_owner, user_id: user.id, store_id: store.id)
    # puts user.stores.inspect
    # puts store.inspect
    assert_equal(user.stores, [store])
  end

  test "in_group_with?" do
    user = FactoryGirl.create(:user)
    group = FactoryGirl.create(:group, user_id: user.id)
    membership = FactoryGirl.create(:membership, group_id: group.id, user_id: user.id)
    user2 = FactoryGirl.create(:user)
    membership2 = FactoryGirl.create(:membership, group_id: group.id, user_id: user2.id)
    user3 = FactoryGirl.create(:user)

    assert_equal(true, user.in_group_with?(user2))
    assert_false user.in_group_with?(user3)
  end

end
