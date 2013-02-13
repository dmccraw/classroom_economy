# == Schema Information
#
# Table name: charges
#
#  id          :integer          not null, primary key
#  account_id     :integer
#  group_id    :integer
#  description :text
#  amount      :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Charge < ActiveRecord::Base
  belongs_to :account
  belongs_to :group

  attr_accessible :amount, :description, :account_id, :group_id

  validates :account_id, presence: true
  validates :group_id, presence: true

  validates :description, presence: true, length: { maximum: 255 }
  validates :amount, presence: true, numericality: { :greater_than => 0.0 }
end
