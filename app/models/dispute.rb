# == Schema Information
#
# Table name: disputes
#
#  id             :integer          not null, primary key
#  owner_id       :integer
#  owner_type     :string(255)
#  transaction_id :integer
#  group_id       :integer
#  reason         :string(255)
#  result         :integer
#  result_reason  :string(255)
#  result_transaction_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#


class Dispute < ActiveRecord::Base
  # associations
  belongs_to :transaction
  belongs_to :result_transaction, class_name: "Transaction"
  belongs_to :group
  belongs_to :owner, polymorphic: true

  # validations
  validates :owner_id, presence: true
  validates :owner_type, presence: true, length: { maximum: 255 }
  validates :transaction_id, presence: true
  validates :group_id, presence: true
  validates :reason, presence: true, length: { maximum: 255 }
  validates :result_reason, length: { maximum: 255 }

  # attr_accessible
  attr_accessible :reason, :result, :result_reason, :transaction_id, :owner_id, :owner_type, :group_id

  # callbacks
  after_save :transfer_funds

  # this is so that the transfer funds can have the current user in it
  attr_accessor :current_user_id

  # reasons
  APPROVE = 1
  DENY = 2

  def display_result
    case self.result
    when APPROVE
      "Approved"
    when DENY
      "Denied"
    end
  end

  private

  # transfer funds if the result has been set
  def transfer_funds
    if self.result != nil && self.result_transaction_id == nil
      if transaction = Transaction.create(
          group_id: self.group_id,
          from_account_id: self.transaction.to_account_id,
          to_account_id: self.transaction.from_account_id,
          amount: self.transaction.amount,
          description: "Dispute of Transaction #{self.transaction.id} was #{self.result == Dispute::APPROVE ? "approved" : "denied"}. \"#{self.reason}\"",
          user_id: self.current_user_id,
          occurred_on: DateTime.now
        )
        transaction.save!
        update_attribute(:result_transaction_id, transaction.id)
      end
    end
  end

end
