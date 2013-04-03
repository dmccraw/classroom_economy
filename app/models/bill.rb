# == Schema Information
#
# Table name: bills
#
#  id              :integer          not null, primary key
#  from_account_id :integer
#  to_account_id   :integer
#  group_id        :integer
#  user_id         :integer
#  due_date        :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  paid            :boolean
#  paid_date       :datetime
#  transaction_id  :integer
#  amount          :float
#  description     :string(255)
#

class Bill < ActiveRecord::Base
  # associations
  belongs_to :from_account, class_name: "Account"
  belongs_to :to_account, class_name: "Account"
  belongs_to :group
  belongs_to :user
  belongs_to :transaction

  # attr_accessible
  attr_accessible :from_account_id, :due_date, :paid, :paid_date, :amount, :description, :transaction_id

  # validations
  validates :from_account_id, presence: true
  validates :to_account_id, presence: true
  validates :group_id, presence: true
  validates :user_id, presence: true
  validates :due_date, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0.0 }
  validates :description, presence: true, length: { minimum: 3, maximum: 255 }

  validates :paid_date, presence: true, if: :paid
  validates :transaction_id, presence: true, if: :paid

  # scopes
  scope :paid, where("paid is true")
  scope :unpaid, where("paid is not true")

  def pay(current_user)
    # create a transaction and make sure the transaction is successful
    transaction = Transaction.new(
      from_account_id: from_account_id,
      to_account_id: to_account_id,
      user_id: current_user.id,
      group_id: group_id,
      amount: amount,
      description: "Pay bill: #{description}",
      occurred_on: created_at
    )
    if transaction.save
      update_attributes(
        paid: true,
        paid_date: DateTime.now,
        transaction_id: transaction.id
      )
    else
      errors.add(:base, "Unable to create a transaction. #{transaction.errors.full_message.join(", ")}")
      false
    end
  end
end
