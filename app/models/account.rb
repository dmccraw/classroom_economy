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
  # associations
  belongs_to :owner, polymorphic: true
  belongs_to :group
  has_many :charges, dependent: :destroy

  # attr_accessible
  attr_accessible :balance, :owner_id, :owner_type, :group_id

  # validations
  validates :owner_id, presence: true
  validates :owner_type, presence: true, length: { maximum: 255 }
  validates :group_id, presence: true
  validates :balance, presence: true, numericality: true

  # callbacks
  before_save :set_initial_balance
  after_destroy :destroy_transactions

  # scopes
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
    owner.display_name
  end

  private

  def set_initial_balance
    unless self.balance
      write_attribute(:balance, 0.0)
    end
  end

  def destroy_transactions
    Transaction.where("from_account_id = :id OR to_account_id = :id", id: self.id).destroy_all
  end
end
