# == Schema Information
#
# Table name: transactions
#
#  id           :integer          not null, primary key
#  from_user_id :integer
#  to_user_id   :integer
#  amount       :float
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Transaction < ActiveRecord::Base
  belongs_to :from, foreign_key: "user_id"
  belongs_to :to, foreign_key: "user_id"

  validates :from_user_id, presence: true
  validates :to_user_id, presence: true
  validates :description, presence: true

  attr_accessible :amount, :description
end
