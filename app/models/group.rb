# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Group < ActiveRecord::Base
  belongs_to :user
  has_one :store

  has_many :memberships, dependent: :destroy
  has_many :users, :through => :memberships, :source => :user
  has_many :accounts, dependent: :destroy

  attr_accessible :name, :user_id

  validates :name, presence: true

  after_create :create_store


  def can_access?(user)
    (user.user_type == User::USER_TYPE_ADMIN || user.id == self.user_id)
  end

  def members
    members = []
    memberships = Membership.find_all_by_group_id(self.id)
    memberships.each do |member|
      members << member.user if member.user.student?
    end
    members
  end

  def stores
    Store.where(group_id: self.id)
  end

  private

  def create_store
    # every group has their own account
    store = Store.create(name: "#{self.name} Store", group_id: self.id)
    store_owner = StoreOwner.create(user_id: self.user_id, store_id: store.id)
  end

end
