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
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Dispute < ActiveRecord::Base
  # associations
  belongs_to :transaction
  belongs_to :group
  belongs_to :owner

  # validations
  validates :owner_id, presence: true
  validates :owner_type, presence: true, length: { maximum: 255 }
  validates :transaction_id, presence: true
  validates :group_id, presence: true
  validates :reason, presence: true, length: { maximum: 255 }
  validates :result_reason, length: { maximum: 255 }

  # attr_accessible
  attr_accessible :reason, :result, :result_reason, :transaction_id, :owner_id, :owner_type, :group_id


end
