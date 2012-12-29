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
  belongs_to :from, through: :user
  belongs_to :to, through: :user
  attr_accessible :amount, :description

end
