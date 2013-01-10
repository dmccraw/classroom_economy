# == Schema Information
#
# Table name: transactions
#
#  id              :integer          not null, primary key
#  from_account_id :integer          not null
#  to_account_id   :integer          not null
#  amount          :float            not null
#  description     :string(255)      not null
#  occurred_on     :datetime         not null
#  user_id         :integer          not null
#  group_id         :integer          not null
#  disputed        :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Transaction < ActiveRecord::Base
  # relationships
  belongs_to :from_account, class_name: "Account"
  belongs_to :to_account, class_name: "Account"
  belongs_to :user
  belongs_to :group

  # access
  attr_accessible :from_account_id, :to_account_id, :amount, :description, :disputed, :occurred_on, :user_id

  # validations
  validates :from_account_id, presence: true
  validates :to_account_id, presence: true
  validates :amount, presence: true, numericality: { :greater_than => 0.0, }
  validates :description, presence: true, length: { minimum: 3, maximum: 255 }
  validates :user_id, presence: true
  validates :occurred_on, presence: true

  # callbacks
  after_create :transfer_funds

  private

  def transfer_funds
    from_account.update_attributes(balance: from_account.balance - amount)
    to_account.update_attributes(balance: to_account.balance + amount)
  end
end
