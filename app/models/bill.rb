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
  attr_accessible :to_account_id, :due_date, :paid, :paid_date, :amount, :description

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
end
