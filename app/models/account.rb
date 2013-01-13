# == Schema Information
#
# Table name: accounts
#
#  id         :integer          not null, primary key
#  owner_id   :integer
#  owner_type :string(255)
#  group_id   :integer
#  balance    :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# owner_id, polymorphic user or store

class Account < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
  belongs_to :group
  attr_accessible :balance, :owner_id, :owner_type, :group_id

  before_save :set_initial_balance

  scope :users, where("owner_type = ?", "User")
  scope :stores, where("owner_type = ?", "Store")

  def user?
    self.owner_type == "User"
  end

  def store?
    self.owner_type == "Store"
  end


  def transactions
    Transaction.where("from_account_id = :id OR to_account_id = :id", id: self.id)
  end

  def display_name
    if user?
      owner.display_name
    elsif store?
      owner.name
    else
      "Unknown Account"
    end
  end

  private

  def set_initial_balance
    unless self.balance
      write_attribute(:balance, 0.0)
    end
  end
end
