# == Schema Information
#
# Table name: disputes
#
#  id                    :integer          not null, primary key
#  owner_id              :integer
#  owner_type            :string(255)
#  transfer_id        :integer
#  group_id              :integer
#  reason                :text
#  result                :integer
#  result_reason         :text
#  result_transfer_id :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#


class Dispute < ActiveRecord::Base
  # associations
  belongs_to :transfer
  belongs_to :result_transfer, class_name: "Transfer"
  belongs_to :group
  belongs_to :owner, polymorphic: true

  # validations
  validates :owner_id, presence: true
  validates :owner_type, presence: true, length: { maximum: 255 }
  validates :transfer_id, presence: true
  validates :group_id, presence: true
  validates :reason, presence: true, length: { maximum: 255 }
  validates :result_reason, length: { maximum: 255 }

  # attr_accessible
  attr_accessible :reason, :result, :result_reason, :transfer_id, :owner_id, :owner_type, :group_id

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
    if self.result != nil && self.result_transfer_id == nil
      if transfer = Transfer.create(
          group_id: self.group_id,
          from_account_id: self.transfer.to_account_id,
          to_account_id: self.transfer.from_account_id,
          amount: self.transfer.amount,
          description: "Dispute of Transfer #{self.transfer.id} was #{self.result == Dispute::APPROVE ? "approved" : "denied"}. \"#{self.reason}\"",
          user_id: self.current_user_id,
          occurred_on: DateTime.now
        )
        transfer.save!
        update_attribute(:result_transfer_id, transfer.id)
      end
    end
  end

end
