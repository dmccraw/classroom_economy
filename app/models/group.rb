# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Group < ActiveRecord::Base
  # associations
  belongs_to :user

  has_many :memberships
  has_many :users, :through => :memberships, :source => :user
  has_many :accounts, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :job_assignments, dependent: :destroy
  has_many :transactions
  has_many :disputes, dependent: :destroy
  has_many :charges#, dependent: :destroy
  has_many :stores, dependent: :destroy
  has_many :bills, dependent: :destroy

  # attr accessible
  attr_accessible :name

  # validations
  validates :name, presence: true, length: { maximum: 255 }
  validates_uniqueness_of :name, :scope => :user_id

  # callbacks
  after_create :create_store
  after_destroy :destroy_users

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

  def store
    Store.where(group_id: self.id).order("created_at ASC").limit(1).first
  end

  def stores
    Store.where(group_id: self.id)
  end

  def student_stores
    Store.where(group_id: self.id).order("created_at ASC").offset(1)
  end

  def member_of?(user)
    members.each do |member|
      if user.id == member.id
        return true
      end
    end
    false
  end

  def group_account
    # Account.where(group_id: self.id, owner_type: "Store", owner_id: store_id).first
    store.account
  end

  def transactions
    Transaction.where("to_account_id IN (:account_ids) OR from_account_id in (:account_ids)", account_ids: accounts.map() {|a| a.id})
  end

  def account_transactions(account_id)
    Transaction.where("to_account_id = (:account_id) OR from_account_id = (:account_id)", account_id: account_id)
  end

  private

  def create_store
    # every group has their own account
    store = Store.create(name: "#{self.name} Store", group_id: self.id, approved: true)
    store.account.update_attributes(balance: 1000000.00)
    store_owner = StoreOwner.create(user_id: self.user_id, store_id: store.id)
  end

  def destroy_users
    # destroy the students if this is their only group
    users.each do |user|
      if user.groups.count == 1
        user.destroy
      end
    end
    Transaction.where(group_id: self.id).destroy_all
  end

end
