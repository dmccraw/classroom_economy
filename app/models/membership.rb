# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  group_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  attr_accessible :user_id, :group_id

  after_save :create_account

  private

  def create_account
    Account.create(owner_id: user_id, owner_type: "User", group_id: group_id, balance: 0.0)
  end
end
