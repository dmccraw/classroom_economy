# == Schema Information
#
# Table name: transfers
#
#  id              :integer          not null, primary key
#  from_account_id :integer          not null
#  to_account_id   :integer          not null
#  group_id        :integer          not null
#  amount          :float            not null
#  description     :string(255)      not null
#  occurred_on     :datetime         not null
#  user_id         :integer          not null
#  disputed        :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Transfer < ActiveRecord::Base
  # relationships
  belongs_to :from_account, class_name: "Account"
  belongs_to :to_account, class_name: "Account"
  belongs_to :user
  belongs_to :group
  has_many :disputes

  # access
  attr_accessible :from_account_id, :to_account_id, :amount, :description, :disputed, :occurred_on, :user_id, :group_id

  # validations
  validates :from_account_id, presence: true
  validates :to_account_id, presence: true
  validates :amount, presence: true, numericality: { :greater_than => 0.0, }
  validates :description, presence: true, length: { minimum: 3, maximum: 255 }
  validates :user_id, presence: true
  validates :occurred_on, presence: true

  validate :different_from_to_accounts
  validate :occurred_in_the_past

  # callbacks
  after_create :transfer_funds

  # transfer the money without a transfer and delete this transfer
  # effectively erases the transfer
  def undo
    if from_account && to_account
      from_account.balance += amount
      to_account.balance -= amount
      from_account.save
      to_account.save
    end

    self.destroy
  end

  private

  def different_from_to_accounts
    if from_account_id == to_account_id
      errors.add(:base, "To and From accounts must be different")
    end
  end

  def store_approved
    if from_account.store? || to_account.store?
      if from_account.store? && !from_account.owner.approved
        errors.add(:from_account, "From store has not been approved.")
      end
      if to_account.store? && !to_account.owner.approved
        errors.add(:to_account, "From store has not been approved.")
      end
    end
  end

  def occurred_in_the_past
    if self.occurred_on
      errors.add(:occurred_on, "Occurred on must be in the past") if self.occurred_on > DateTime.now
    end
  end

  def transfer_funds
    from_account.update_attributes(balance: from_account.balance - self.amount)
    to_account.update_attributes(balance: to_account.balance + self.amount)
  end
end
