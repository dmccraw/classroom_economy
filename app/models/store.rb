# == Schema Information
#
# Table name: stores
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  group_id    :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Store < ActiveRecord::Base
  has_many :users, through: :store_owners
  has_many :store_owners
  has_one :account, as: :owner
  belongs_to :group

  attr_accessible :description, :name, :group_id, :balance

  after_create :create_account

  def edit_store?(user)
    return true if user.admin?
    return owner?(user)
  end

  def owner?(user)
    users.each do |local_user|
      return true if local_user == user
    end
    false
  end

  private

  def create_account
    Account.create(owner_id: self.id, owner_type: self.class.to_s, group_id: group_id)
  end
end
