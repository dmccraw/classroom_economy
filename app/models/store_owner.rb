# == Schema Information
#
# Table name: store_owners
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  store_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class StoreOwner < ActiveRecord::Base
  belongs_to :user
  belongs_to :store

  attr_accessible :user_id, :store_id
end
