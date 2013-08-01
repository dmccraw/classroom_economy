# == Schema Information
#
# Table name: stores
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  description :text
#  approved    :boolean          default(FALSE), not null
#  group_id    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Store < ActiveRecord::Base
  has_many :users, through: :store_owners
  has_many :store_owners, dependent: :destroy
  has_many :store_managers, dependent: :destroy
  has_one :account, as: :owner, dependent: :destroy
  belongs_to :group

  attr_accessible :description, :name, :group_id, :balance, :approved

  after_create :create_account

  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where(approved: false) }

  # validations
  validates :name, uniqueness: { scope: :group_id }

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

  def manager?(user)
    store_managers.each do |store_manager|
      return true if user.id == store_manager.user_id
    end
    false
  end

  def display_name
    self.name
  end

  def class_store?
    # if any store owner
    group.store == self
  end

  private

  def create_account
    Account.create(owner_id: self.id, owner_type: self.class.to_s, group_id: self.group_id, balance: 0.0)
  end

end
